
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
    @rows, @colums = [], []
    begin
      @thead = I18n.t('reports.report1.thead').split(",")
      @report_name = "report1"
      @current = 1
      @total = 0.0  
      @date = params[:date] + " " + params[:date_time]
      @date_end = params[:date_end] + " " + params[:date_end_time]
      @stores = params[:stores]
      client = TinyTds::Client.new(:username => 'TrueVUE_SA', :password => 'TrueVUE_SA', :dataserver => 'localhost\MSSQLSERVER', :database => 'VUE_DM')
      query_report1 = QUERIES['report1'].gsub("%_DATE_%", @date).gsub("%_DATE_END_%", @date_end).gsub("%_STORES_%", @stores)
      query = QUERIES['query'].gsub("%_QUERY_%", query_report1).gsub("%_COLUMS_%", QUERIES['report1_colums']) + QUERIES['report1_order_by'].gsub("%_COLUMS_%", QUERIES['report1_colums'])
      result = client.execute(query)  
      #logger.info "QUERY " + query.to_s
      i = 0
      result.each do |rowset|
        @rows.push(rowset) if i < QUERIES['rows'].to_i
        i += 1
      end
      logger.info "total_rows " + i.to_s

      @colums = QUERIES['report1_colums'].split(",")
      @total = (i /  QUERIES['rows'].to_f).ceil
      #logger.info @colums.inspect
    rescue Exception => e
      logger.info "Error en report1 " + e.message
      logger.error $!.backtrace 
    end
    respond_with @rows
  end

  def report_query
    @rows = []
    thead, colums = [], []
    total = params[:total]
    page = params[:page].nil? ? 1 : params[:page].to_i
    begin
      colums = QUERIES[params[:report] + "_colums"]
      thead = I18n.t('reports.' + params[:report] + '.thead').split(",")
      date = params[:date]
      date_end = params[:date_end]
      stores = params[:stores]  
      limit = QUERIES['rows'].to_i
      end_row = (limit * page)
      start_row = end_row - (limit - 1)
      client = TinyTds::Client.new(:username => Rails.application.config.dbuser, :password => Rails.application.config.dbpassword, :dataserver => Rails.application.config.dbdataserver, :database => Rails.application.config.dbname)
      query_report = QUERIES[params[:report]].gsub("%_DATE_%", date).gsub("%_DATE_END_%", date_end).gsub("%_STORES_%", stores)
      query_group = QUERIES['query'].gsub("%_QUERY_%", query_report).gsub("%_COLUMS_%", colums)
      query = QUERIES['pagination'].gsub("%_QUERY_%", query_group).gsub("%_startRow_%", start_row.to_s).gsub("%_endRow_%", end_row.to_s).gsub("%_DATE_%", date).gsub("%_DATE_END_%", date_end).gsub("%_STORES_%", stores) + QUERIES[ params[:report] + '_order_by'].gsub("%_COLUMS_%", colums)
      result = client.execute(query)      
      #logger.info "QUERY " + query.to_s
      result.each do |rowset|
        @rows.push(rowset)
      end
    rescue Exception => e
      logger.info "Error en report_query " + e.message
      logger.error $!.backtrace 
    end
    respond_with do |format|
      format.html { render :partial => "reports/table", :locals => { :rows => @rows, :thead => thead, :total => total, :current => page, :colums => colums.split(",") } and return }
      format.json { render :json => @rows.to_json }
    end
  end
end
