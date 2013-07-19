(function ($) {
	$.extend($.ui, { DateTimepicker: {} });


	$.datepicker._base_updateDatepicker = $.datepicker._updateDatepicker;
	$.datepicker._updateDatepicker = function (inst) {
		$.datepicker._base_updateDatepicker(inst);

		var val = inst.input.val();

		if (inst.input.hasClass("datetimepicker") == false) return;

		var bottomLayer = $(".ui-datepicker").append("<div class='.datetimepicker' />");
		bottomLayer.append(html1);
		bottomLayer.append(":");
		bottomLayer.append(html2);
		bottomLayer.append(":");
		bottomLayer.append(html3);

		$.datetimepicker.setTime(val + " " + $("#" + inst.input.data("time")).val(), inst.input);
	};


	function DateTimePicker(options) {

		this.defaultDateTimePicker =
			{
				showTimePicker: false,
				time_format: 'hh:mm:ss'
			};

		hourHTML = $("<select class='datetimepicker-hour' onchange='$.datetimepicker.isDirty = true;'></select>");
		minutsHTML = $("<select class='datetimepicker-minuts' onchange='$.datetimepicker.isDirty = true;'></select>");
		secondHTML = $("<select class='datetimepicker-second' onchange='$.datetimepicker.isDirty = true;'></select>");

		for (i = 0; i <= 23; i++) {
			var hour_temp = i;
			if(i<10) {
				hour_temp = "0" + i;
			} 
			html1 = hourHTML.append("<option>" + hour_temp + "</option");
		}
		for (i = 0; i < 60; i = i + 5) {
			var minut_temp = i;
			if(i<10) {
				minut_temp = "0" + i;
			} 
			html2 = minutsHTML.append("<option>" + minut_temp + "</option");
		}
		for (i = 0; i < 60; i = i + 5) {
			var second_temp = i;
			if(i<10) {
				second_temp = "0" + i;
			} 
			html3 = secondHTML.append("<option>" + second_temp + "</option");
		} 
	}

	$.fn.extend({
		datetimepicker: function (options) {

			$.datetimepicker._attach(this, options);
		}
	});

	DateTimePicker.prototype = {
		_initTimePicker: function () {
		},

		isDirty: false,

		innerOption: function ($this) {

			return {
				changeMonth: true,
				changeYear: true,
				autoSize: true,
				onSelect: function (a, b) {
					var hour = $('.ui-datepicker .datetimepicker-hour').val();
					var minuts = $('.ui-datepicker .datetimepicker-minuts').val();
					var second = $('.ui-datepicker .datetimepicker-second').val();

					var time = hour + ":" + minuts + ":" + second;
					$("#" + $this.data("time")).val(time);

					$.datetimepicker.setTime($this.val() + " " + time, $this);

					$.datetimepicker.reset();
				},
				onClose: function (a, b) {
					if ($.datetimepicker.isDirty) {
						$this.val($.datepicker._formatDate(b));

						var hour = $('.ui-datepicker .dateimepicker-hour').val();
						var minuts = $('.ui-datepicker .dateimepicker-minuts').val();
						var second = $('.ui-datepicker .dateimepicker-second').val();

						var time = hour + ":" + minuts + ":" + second;
						$("#" + $this.data("time")).val(time);

					}
				}
			};
		},

		_attach: function ($this, options) {
			$this.datepicker($.fn.extend(this.innerOption($this), options))
				.addClass("datetimepicker");

			this.setTime($this.val() + " " + $("#" + $this.data("time")).val(), $this);

		},

		reset: function () {
			this.isDirty = false;
		},

		setTime: function (format, $this) {
			var arrStr = format.split(' ');

			var hour = "12";
			var minuts = "00";
			var second = "00";

			if (arrStr.length > 1) {
				var strTime = arrStr[1];
				var arr = strTime.split(':');
				if (arr.length > 0) {
					hour = arr[0];
					if (arr.length > 1) minuts = arr[1];
					if (arr.length > 2) second = arr[2];
				}
			}

			$('.ui-datepicker .datetimepicker-hour').val(hour);
			$('.ui-datepicker .datetimepicker-minuts').val(minuts);
			$('.ui-datepicker .datetimepicker-second').val(second);
		}
	};


	$.datetimepicker = new DateTimePicker();
	$.datetimepicker._initTimePicker();

} (jQuery));