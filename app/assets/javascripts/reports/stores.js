
/**
 * Controlador encargado del manejo de las rutas
 */
Reports.StoresController = function() { 
};

/**
 * Funcion que inicializa el mapa y eventos necesarios
 */
Reports.StoresController.prototype.init = function() {
	var stores = $("#filter_form").data("stores");
	var children = new Array();
    $("#tree").dynatree({
        onSelect: function(flag, node) {
            //if( ! flag )
              //  alert("You deselected node with title " + node.data.title);
            var selectedNodes = node.tree.getSelectedNodes();
            var selectedKeys = $.map(selectedNodes, function(node){
            	if(node.data.id < 0) {
                	return node.data.id * -1;
            	} else {
            		return null;
            	}
            });
            //alert("Selected keys: " + selectedKeys.join(","));
            $("#stores").val(selectedKeys.join(","));
        },
        checkbox: true,
        persist: false,
        autoCollapse: false,
        selectMode: 3,
        children: stores // Pass an array of nodes.
    }); 

	if(!Modernizr.inputtypes.datetime) {
	    $('.date_type').remove();
	    $( "#date" ).datetimepicker({
			defaultDate: "+1w",
			changeMonth: true,
			numberOfMonths: 1,
			dateFormat: "yy-mm-dd"
		});
	    $( "#date" ).on('change', function() {$( "#date_end" ).datepicker( "option", "minDate", $(this).val() );});
	    $( "#date_end" ).datetimepicker({
			defaultDate: "+1w",
			changeMonth: true,
			numberOfMonths: 1,
			dateFormat: "yy-mm-dd"
		});
	    $( "#date_end" ).on('change', function() {$( "#date" ).datepicker( "option", "maxDate", $(this).val() );});
	} else {
	    $('.datepicker_type').remove();
	}
}

/**
 * Funcion que inicializa el controlador de rutas para utilizarlo en toda la aplicacion
 */
$(function() {
  Reports.stores = new Reports.StoresController();
  Reports.stores.init();
});