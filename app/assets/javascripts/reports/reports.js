
/**
 * Controlador encargado del manejo de las rutas
 */
Reports.ReportsController = function() { 
	this.cache = {};
	this.report = null;
	this.total = null;
};

/**
 * Funcion que inicializa los eventos necesarios
 */
Reports.ReportsController.prototype.init = function() {
	$(document.body).on('click', '.pagination a', this.on_paginate);
	this.report = $("#report").data("report");
	this.total = $("#report").data("total");
	Reports.reports.cache["1"] = $(".table_result").eq(0).html();	
}

/**
 * Funcion de paginacion
 */
Reports.ReportsController.prototype.on_paginate = function(e) {
	e.preventDefault();
	var $li = $(this).parent("li").eq(0);
	if($li.hasClass("unavailable") || $li.hasClass("current")) {
		return false;
	}
	var page = $li.data("page");
	if($li.hasClass("arrow")) {
		if($li.hasClass("left_pagination")) {
			page = $(".pagination .current").data("page") - 1;
		} else {
			page = $(".pagination .current").data("page") + 1;
		}
	}
	if(!Reports.reports.cache[page]) {
		$.ajax({
        url: Reports.REPORTS_URL + "report_query",
        data: {
        	page: page, 
        	total: Reports.reports.total, 
        	report: Reports.reports.report, 
        	date: $(".table_result").eq(0).data("date"), 
        	date_end: $(".table_result").eq(0).data("date_end"), 
        	stores: $(".table_result").eq(0).data("stores")
        },
        dataType: 'html',
        type: 'get'
      })
      .done(function(data) {
        Reports.reports.cache[page] = data;
        $(".table_result").eq(0).html(data);
      })
      .fail()
      .always(function(data) {
      })
	} else {
        $(".table_result").eq(0).html(Reports.reports.cache[page]);
	}

}

/**
 * Funcion que inicializa el controlador de rutas para utilizarlo en toda la aplicacion
 */
$(function() {
  Reports.reports = new Reports.ReportsController();
  Reports.reports.init();
});