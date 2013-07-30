INSTALACI�N

	1. Se debe descargar la aplicacion bitnami para Ruby para Sistema Operativo Windows de la siguiente pagina:
		http://bitnami.com/stack/ruby
	2. Una vez descargada se debe instalar sin instalar los ejemplos ni PHP y se debe instalar en la ubicacion que desee, se recomienda c:/bitnami.
		En la instalacion pedira ingresar el puerto en el que correra el servidor Apache, por defecto esta el puerto 80, para este caso se recomienda colocar un puerto libre en el que no este corriendo ninguna aplicacion.
	3. Una vez instalada satisfactoriamente se debe verificar que el apache este corriendo correctamente ingresando en el navegador la siguiente 					direccion 			reemplazando las x por el puerto que se coloco en la instalaci�n: 'http://localhost:XXXX' , debe aparecer una pagina de bienvenida.
	4. Se debe copiar la carpeta de codigo fuente 'ReportesMovilesTrueVUE' en la ubicaci�n que desee.
	5. Se debe crear una varible de entorno del sistema llamada 'MOBILE_REPORT' y se le debe asignar el valor de la ubicaci�n en que se copio el codigo fuente, por ejemplo: 'c:\projects\ReportesMovilesTrueVUE'.
	6. Se deben agregar la siguiente ruta en la variable de sistema 'Path', la ruta donde esta instalado Ruby que seria como la siguiente": 'c:\bitnami\RubyStac-X.X.X\ruby'
	7. Se debe correr el archivo 'reportes.bat' ubicado en la carpeta del codigo fuente, este iniciar� la consola de comandos de Windows, esta consola no se debe cerrar para que la aplicacion continue corriendo.
	8. Una vez aparezca en la consola un mensaje que indica que el servidor esta corriendo, se puede ingresar en el navegador de internet la siguiente direcci�n:	'http://localhost:3000' y se debe iniciar la aplicacion de reportes.
	9. Despues para que la aplicaci�n funcione aunque reinicien el computador se debe crear una tarea programada en la aplicacion 'Task Scheduler' que se corra cada vez que inicia el equipo llamada "Iniciar Reportes Moviles", que inicie una aplicaci�n corriendo el archivo 'reportes.bat' ubicado en la carpeta de codigo fuente (por ejemplo: 'c:/projects/ReportesMovilesTrueVUE/reportes.bat').
	10. El log de la aplicacion estar� disponible en la ubicacion del proyecto, en la carpeta 'log' en el archivo 'production.log' que se puede abrir con un editor de texto convencional.

CONFIGURACI�N
	En estas configuraciones se utiliza la llave 'report1' que representa el reporte de 'Tasa de conversi�n por tienda', si en algun caso se agregan mas reportes estos ser�n puestos con la llave 'report' concatenado al n�mero de reporte.

	CONSULTAS
		Las consultas a la base de datos estan configuradas en el archivo 'queries.yml' ubicado en la carpeta 'config' en el directorio del proyecto. Las consutas estan dispuestas as�:
		- stores: Consulta hecha para obtener las tiendas del filtro del reporte con su jerarqu�a, debe tener los siguientes campos: 'id', 'title', 'type' y 'parent' y deben ir ordenados en forma descendente por el valor del campo 'parent' para que funcione correctamente la logica de jerarquias. 
		- report1: Consulta para obtener los datos del reporte de 'Tasa de conversi�n por tienda' esta consulta debe tener los siguientes campos: 'PARENTHIERARCHYID', 'PARENTHIERARCHYNAME', 'PARENTHIERARCHYTYPE', 'HIERARCHYID', 'HIERARCHYNAME', 'VUEHIERARCHYID', 'SITECODE', 'HIERARCHYDATADATE', 'HIERARCHYDATADAY', 'HIERARCHYTRANSACTIONDATECOUNT', 'HIERARCHYSALESDATETOTAL', 'HIERARCHYITEMDATECOUNT', 'HIERARCHYPEOPLEDATECOUNT', 'HIERARCHYCONVERSIONDATERATE', 'HIERARCHYAVERAGEDATESALES' y 'HIERARCHYAVERAGEDATEUNITS'
		- report1_columns: Aqu� deben estar las columnas que entrega la consulta del reporte anterior, que seran mostradas en la tabla de resultados. El orden en que se pongan estas columnas ser� en el orden en que se mostrar�n los datos en la tabla de resultados, el nombre de estas columnas debe ir separado por comas y sin espacios.
		- report1_order_by: NO debe cambiar, utilizado para la logica interna de los reportes.
		- query: NO debe cambiar, utilizado para la logica interna de los reportes.
		- pagination: NO debe cambiar, utilizado para la logica interna de los reportes.
		- rows: N�mero de registros que tendr� cada p�gina de resultados en el reporte.
	
	CABECERA DE TABLA DE RESULTADOS
		Estas cabeceras estan configuradas en el archivo 'reports.es.yml' ubicado en la carpeta 'config/locales' en el directorio del proyecto. Se debe buscar la llave 'es.reports.report1.thead', estos nombres estan separados por comas y sin espacios, tener en cuenta que el n�mero de campos puestos aca deben ser iguales a los del campo 'report1_colums' 

	USUARIO Y CONTRASE�A
		El usuario y contrase�a para ingresar a la aplicaci�n estan configuarados en el archivo 'users.yml' ubicado en la carpeta 'config' en el directorio del proyecto.
		Para modificar usuario o contrase�a se debe encriptar la palabra utilizando MD5, esto se puede hacer en una pagian de internet como la siguiente:
		'http://www.md5.net/'
		Las cadenas obtenidas se deben copiar y asignar a las llaves 'login' para el usuario y 'password' para la contrase�a, estos valores deben estar entre comillas dobles '"'.