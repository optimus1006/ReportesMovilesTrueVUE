
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
    @rows = []
    begin
      @thead = I18n.t('reports.report1.thead').split(",")
      @report_name = "report1"
      @current = 1
      @total = 0.0  
      @date = params[:date] + " " + params[:date_time]
      @date_end = params[:date_end] + " " + params[:date_end_time]
      @stores = params[:stores]
      client = TinyTds::Client.new(:username => 'TrueVUE_SA', :password => 'TrueVUE_SA', :dataserver => 'localhost\MSSQLSERVER', :database => 'VUE_DM')
      query = QUERIES['report1'].gsub("%_DATE_%", @date).gsub("%_DATE_END_%", @date_end).gsub("%_STORES_%", @stores) + QUERIES['report1_order_by']
      result = client.execute(query)
      i = 0
      result.each do |rowset|
        @rows.push(rowset) if i < QUERIES['rows'].to_i
        i += 1
      end
      logger.info "total_rows " + i.to_s

      @total = (i /  QUERIES['rows'].to_f).ceil
    rescue Exception => e
      logger.info "Error en report1 " + e.message
      logger.error $!.backtrace 
    end
    respond_with @rows
  end

  def report_query
    @rows = []
    thead = []
    total = params[:total]
    page = params[:page].nil? ? 1 : params[:page].to_i
    begin
      date = params[:date]
      date_end = params[:date_end]
      stores = params[:stores]
      limit = QUERIES['rows'].to_i
      end_row = (limit * page)
      start_row = end_row - (limit - 1)
      client = TinyTds::Client.new(:username => Rails.application.config.dbuser, :password => Rails.application.config.dbpassword, :dataserver => Rails.application.config.dbdataserver, :database => Rails.application.config.dbname)
      query = QUERIES['pagination'].gsub("%_QUERY_%", QUERIES[params[:report]]).gsub("%_startRow_%", start_row.to_s).gsub("%_endRow_%", end_row.to_s).gsub("%_DATE_%", date).gsub("%_DATE_END_%", date_end).gsub("%_STORES_%", stores) + QUERIES[ params[:report] + '_order_by']
      result = client.execute(query)
      result.each do |rowset|
        @rows.push(rowset)
      end
      thead = I18n.t('reports.' + params[:report] + '.thead').split(",")
    rescue Exception => e
      logger.info "Error en report_query " + e.message
      logger.error $!.backtrace 
    end
    respond_with do |format|
      format.html { render :partial => "reports/table", :locals => { :rows => @rows, :thead => thead, :total => total, :current => page } and return }
      format.json { render :json => @rows.to_json }
    end
  end
end
