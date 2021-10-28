﻿
&Вместо("ЗаполнитьПоЗаказуКлиента")
Процедура Рин1_ЗаполнитьПоЗаказуКлиента(ДанныеЗаполнения)
	
		ЗаказКлиента = ДанныеЗаполнения.Основание;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаказКлиента.Статус                  КАК СтатусДокумента,
	|	ЗаказКлиента.Проведен                КАК Проведен,
	|	ЗаказКлиента.Организация             КАК Организация,
	|	ВЫБОР КОГДА ЗаказКлиента.Сделка.ОбособленныйУчетТоваровПоСделке ТОГДА
	|				ЗаказКлиента.Сделка
	|		КОНЕЦ                            КАК Сделка,
	|	ЗаказКлиента.Подразделение           КАК Подразделение,
	|	ЗаказКлиента.НаправлениеДеятельности КАК НаправлениеДеятельности
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка = &ЗаказКлиента");
	
	Запрос.УстановитьПараметр("ЗаказКлиента", ЗаказКлиента);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Документы.ЗаказКлиента.ПроверитьВозможностьВводаНаОсновании(
		ЗаказКлиента,
		Реквизиты.СтатусДокумента,
		НЕ Реквизиты.Проведен);
	
	// Заполнение шапки
	Организация             = Реквизиты.Организация;
	Сделка                  = Реквизиты.Сделка;
	ДокументОснование       = ЗаказКлиента;
	Подразделение           = Реквизиты.Подразделение;
	НаправлениеДеятельности = Реквизиты.НаправлениеДеятельности;
	СкладПолучатель         = ДанныеЗаполнения.Склад;
	
	// Заполнение табличной части.
	
	ПараметрыТаблицыТовары = ОбеспечениеСервер.ПараметрыТаблицыОстатковПоЗаказу();
	ПараметрыТаблицыТовары.ПолучатьУслуги = Ложь;
	ПараметрыТаблицыТовары.ПолучатьРаботы = Ложь;
	ПараметрыТаблицыТовары.Отбор          = СкладПолучатель;
	//{Гига suv 16.01.2018 СхемыОбеспеченияДляЗаказов
	Если ДанныеЗаполнения.Свойство("АвтоформированиеПеремещения") Тогда 
		ГИГ_СформированАвтоматически = Истина;
		ПараметрыТаблицыТовары.Вставить("ТаблицаТовары",ДанныеЗаполнения.ТаблицаТовары);
	КонецЕсли;
	//Гига suv 16.01.2018}
	ТаблицаТовары = ОбеспечениеСервер.ТаблицаОстатковКЗаказу(ЗаказКлиента, ПараметрыТаблицыТовары);
	Товары.Загрузить(ТаблицаТовары);
	
КонецПроцедуры


