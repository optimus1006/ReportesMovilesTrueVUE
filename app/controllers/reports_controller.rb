include ActionView::Helpers::NumberHelper
include ActionView::Helpers::DateHelper

class ReportsController < ApplicationController
  before_filter :verify_authentication
  layout 'reports'
  respond_to :json
  respond_to :html

  def index
  end

  def stores
    @stores = []
    begin
      client = TinyTds::Client.new(:username => 'TrueVUE_SA', :password => 'TrueVUE_SA', :dataserver => 'localhost\MSSQLSERVER', :database => 'VUE_DM')
      print QUERIES['stores']
      result = client.execute(QUERIES['stores'])
      stores_temp = {}
      result.each do |rowset|
        print "ROWSET " + rowset.inspect
        stores_temp[rowset["id"]] = rowset
      end
      result.each do |rowset|
        if rowset["parent"].nil?
          @stores.push(stores_temp[rowset["id"]])
        elsif stores_temp[rowset["parent"]][:children].nil?
          stores_temp[rowset["parent"]][:children] = []
          stores_temp[rowset["parent"]][:children].push(rowset) 
        else
          stores_temp[rowset["parent"]][:children].push(rowset) 
        end
      end
    rescue Exception => e
      logger.info "Error en stores " + e.message
      logger.error $!.backtrace 
    end
    respond_with @stores
  end

  def report1
    @rows, @columns = {}, []
    begin
      @thead = I18n.t('reports.report1.thead').split(",")
      @columns = QUERIES['report1_columns'].split(",")
      @report_name = "report1"
      @current = 1
      @total = 0.0  
      @date = params[:date] + " " + params[:date_time]
      @date_end = params[:date_end] + " " + params[:date_end_time]
      @stores = params[:stores]
      client = TinyTds::Client.new(:username => 'TrueVUE_SA', :password => 'TrueVUE_SA', :dataserver => 'localhost\MSSQLSERVER', :database => 'VUE_DM')
      query_report1 = QUERIES['report1'].gsub("%_DATE_%", @date).gsub("%_DATE_END_%", @date_end).gsub("%_STORES_%", @stores)
      query = QUERIES['query'].gsub("%_QUERY_%", query_report1).gsub("%_COLUMNS_%", QUERIES['report1_columns']) + QUERIES['report1_order_by'].gsub("%_COLUMNS_%", QUERIES['report1_columns'])
      result = client.execute(query)  
      #logger.info "QUERY " + query.to_s
      i = 0
      temp = {}
      page = 1
      @rows[page] = []
      result.each do |rowset|
        #logger.info "TEMP " + temp[rowset["HIERARCHYNAME"].to_s + rowset["HIERARCHYDATADATE"].to_s].to_s
        
        @columns.each do |column|
          value = ""
          if column.include? "COUNT"  
                value = replace_nil(rowset[column.to_s], "0")
            elsif column.include? "RATE"
                value = replace_nil(rowset[column.to_s], "0.0")
                value = number_to_percentage(value.to_f, precision: 2) unless value == "0.0"
            elsif column.include? "SALES"
                value = replace_nil(rowset[column.to_s], "0.0")
                value = number_to_currency(value.to_f, precision: 2) unless value == "0.0"
            elsif column.include? "AVERAGE"
                value = rowset[column.to_s]
                value = number_with_precision(value.to_f, precision: 2) unless value.nil?
            elsif column.include? "DATE"
            value = rowset[column.to_s].strftime('%d/%m/%Y')
          else  
            value = rowset[column.to_s]            
          end
          rowset[column.to_s] = value.to_s
        end

        if temp[rowset["HIERARCHYNAME"].to_s + rowset["HIERARCHYDATADATE"].to_s].nil?
          temp[rowset["HIERARCHYNAME"].to_s + rowset["HIERARCHYDATADATE"].to_s] = 1
          if i == (QUERIES['rows'].to_i * page)
            page += 1
            @rows[page] = []
          end
          @rows[page].push(rowset)
        else
          @rows[page].pop
          @rows[page].push(rowset)
          i -= 1
        end
        i += 1
      end
      logger.info "total_rows " + i.to_s
      @total = (i /  QUERIES['rows'].to_f).ceil
      #logger.info @columns.inspect
    rescue Exception => e
      logger.info "Error en report1 " + e.message
      logger.error $!.backtrace 
    end
    respond_with @rows
  end

  def report_query
    rows = []
    thead, columns = [], []
    total = params[:total]
    page = params[:page].nil? ? 1 : params[:page].to_i
    begin
      rows = JSON.parse(params[:rows])
      columns = QUERIES[params[:report] + "_columns"]
      thead = I18n.t('reports.' + params[:report] + '.thead').split(",")
    rescue Exception => e
      logger.info "Error en report_query " + e.message
      logger.error $!.backtrace 
    end
    respond_with do |format|
      format.html { render :partial => "reports/table", :locals => { :rows => rows, :thead => thead, :total => total, :current => page, :columns => columns.split(",") } and return }
      format.json { render :json => @rows.to_json }
    end
  end

  private


  def replace_nil(value, replace)
    if value.nil? || value.to_s.empty?
      return replace
    end
    value
  end
end
