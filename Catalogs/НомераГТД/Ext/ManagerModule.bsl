﻿
&Вместо("РегистрационныйНомерИСтранаВвоза")
Функция Рин1_РегистрационныйНомерИСтранаВвоза(НомерТаможеннойДекларации)
	СтруктураНомера = РегистрационныйНомер(НомерТаможеннойДекларации);
	//++Шерстюк Ю.Ю. 18.03.2021 в результате проверки рег.номера на корректность он остается зачастую пустым и 
	//это приводит к ошибкам при попытке выгрузить в сторонние системы. Сделано в рамках задачи 6093
	СтруктураНомера.РегистрационныйНомер = Лев(НомерТаможеннойДекларации,27);
	//--Шерстюк Ю.Ю.
	СтруктураНомера.Вставить("СтранаВвозаНеРФ", НЕ ЗначениеЗаполнено(СтруктураНомера.РегистрационныйНомер));
	
	Возврат СтруктураНомера;

КонецФункции
