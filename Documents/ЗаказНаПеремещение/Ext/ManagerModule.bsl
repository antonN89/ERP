﻿
&Вместо("ЗаполнитьВариантОбеспечения")
Функция Рин1_ЗаполнитьВариантОбеспечения(Объект, Форма, Операция, ДанныеЗаполнения, ПараметрыУказанияСерий)
	
	ЭтоВыборОбеспеченияСУчетомСерий = Операция = "СтрокаТовары"
		И ПолучитьФункциональнуюОпцию("ИспользоватьРасширеннуюФормуПодбораКоличестваИВариантовОбеспечения");
	СтруктураДействий = Новый Структура;
	Если Форма <> Неопределено Тогда
		СтруктураДействий.Вставить("ПриИзмененииТипаНоменклатурыИлиВариантаОбеспечения",
			Новый Структура("ЕстьРаботы, ЕстьОтменено", Ложь, Истина));
	КонецЕсли;
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы("КоличествоУпаковок");

	ЖелаемаяДата = Объект.ЖелаемаяДатаПоступления - Объект.ДлительностьПеремещения * 86400; // 86400 - длительность суток.
	ДатаПоУмолчанию = Макс(НачалоДня(ТекущаяДатаСеанса()), ЖелаемаяДата);

	ДлительностьПеремещенияСекунды = Объект.ДлительностьПеремещения * 86400;
	ТекСтрокаТовары = Неопределено;
	Идентификатор   = Неопределено;
	СтарыеЗначения = ОбеспечениеКлиентСервер.КлючОбеспечения();
	НовыеЗначения  = ОбеспечениеКлиентСервер.КлючОбеспечения();
	Счетчик = 0;
	Добавлено = 0;
	
	ПараметрыОбновленияДатыОтгрузки = ОбеспечениеСервер.ПараметрыОбновленияДатыОтгрузкиВДокументе();
	ПараметрыОбновленияДатыОтгрузки.ОтгружатьОднойДатой    = Ложь;
	ПараметрыОбновленияДатыОтгрузки.ЖелаемаяДатаОтгрузки   = ЖелаемаяДата;
	
	ОбеспечениеСервер.СдвинутьДатыИСвернутьДублиСтрок(ДанныеЗаполнения, Операция, ПараметрыОбновленияДатыОтгрузки);
	
	Для Каждого СтрокаОбеспечения Из ДанныеЗаполнения Цикл

		// Выбор существующей, либо добавление новой строки.
		Если Идентификатор <> СтрокаОбеспечения.Идентификатор Тогда

			Идентификатор = СтрокаОбеспечения.Идентификатор;
			Если Операция = "СтрокаТовары" Или Операция = "СтрокиТовары" Или Операция = "Заказ" Тогда
				СтрокаТовары = Объект.Товары.НайтиПоИдентификатору(Идентификатор);
			ИначеЕсли Операция = "ИндексыСтрок" Тогда
				СтрокаТовары = Объект.Товары[Идентификатор + Добавлено];
			КонецЕсли;
			ТекСтрокаТовары = СтрокаТовары;
			ОбработкаТабличнойЧастиКлиентСервер.ПересчитатьСуммы(СтруктураПересчетаСуммы);
			ОбработкаТабличнойЧастиКлиентСервер.ЗаполнитьСтруктуруПересчетаСуммы(СтруктураПересчетаСуммы, ТекСтрокаТовары);

		Иначе
			ТекСтрокаТовары = Объект.Товары.Вставить(Объект.Товары.Индекс(ТекСтрокаТовары) + 1);
			ЗаполнитьЗначенияСвойств(ТекСтрокаТовары, СтрокаТовары);
			ТекСтрокаТовары.КодСтроки = 0;
			Добавлено = Добавлено + 1;
		КонецЕсли;

		// Заполнение полей обеспечения.
		ЗаполнитьЗначенияСвойств(СтарыеЗначения, ТекСтрокаТовары);
		СтарыеЗначения.ДатаОтгрузки = ТекСтрокаТовары.НачалоОтгрузки;
		
		ЗаполнитьЗначенияСвойств(ТекСтрокаТовары, СтрокаОбеспечения, "Количество, ВариантОбеспечения");
		//{Гига suv 11.01.2018 СхемыОбеспеченияДляЗаказов
		ДанныеСхемыОбеспечения = Новый Структура("ГИГ_СхемаОбеспечения, ГИГ_СрокПоставки");
		ЗаполнитьЗначенияСвойств(ДанныеСхемыОбеспечения, СтрокаОбеспечения);
		ЗаполнитьЗначенияСвойств(ТекСтрокаТовары, ДанныеСхемыОбеспечения);
		//Гига suv 11.01.2018}
		Если ЭтоВыборОбеспеченияСУчетомСерий Тогда
			ТекСтрокаТовары.Серия = СтрокаОбеспечения.Серия;
		КонецЕсли;

		Если СтрокаОбеспечения.Отгружено = 0 Тогда
			ТекСтрокаТовары.НачалоОтгрузки = Макс(СтрокаОбеспечения.ДатаОтгрузки, ДатаПоУмолчанию);
			ТекСтрокаТовары.ОкончаниеПоступления = ТекСтрокаТовары.НачалоОтгрузки + Объект.ДлительностьПеремещения * 86400; //86400 - длительность суток
		КонецЕсли;

		ЗаполнитьЗначенияСвойств(НовыеЗначения, ТекСтрокаТовары);
		НовыеЗначения.ДатаОтгрузки = ТекСтрокаТовары.НачалоОтгрузки;
		ОбеспечениеКлиентСервер.СчетИзменений(Счетчик, СтарыеЗначения, НовыеЗначения);

		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекСтрокаТовары, СтруктураДействий, КэшированныеЗначения);
		ОбработкаТабличнойЧастиКлиентСервер.ДобавитьСтрокуДляПересчетаСуммы(СтруктураПересчетаСуммы, ТекСтрокаТовары);

	КонецЦикла;
	ОбработкаТабличнойЧастиКлиентСервер.ПересчитатьСуммы(СтруктураПересчетаСуммы);

	Если ПараметрыУказанияСерий = Неопределено Тогда
		ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ЗаказНаПеремещение));
	КонецЕсли;
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);

	Если Операция = "СтрокаТовары" Или Операция = "СтрокиТовары" Или Операция = "Заказ" Тогда
		Форма.Модифицированность = Истина;
	КонецЕсли;

	Возврат ОбеспечениеКлиентСервер.ТекстОбработаноСтрок(Счетчик);
	
КонецФункции

&Вместо("ТекстЗапросаТаблицаГрафикОтгрузкиТоваров")
Функция Рин1_ТекстЗапросаТаблицаГрафикОтгрузкиТоваров(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ГрафикОтгрузкиТоваров";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.НачалоОтгрузки           КАК Период,
	|	ТаблицаТовары.НачалоОтгрузки           КАК ДатаОтгрузки,
	|
	//{Гига suv 11.01.2018 СхемыОбеспеченияДляЗаказов
	|	ТаблицаТовары.ГИГ_СхемаОбеспечения	   КАК ГИГ_СхемаОбеспечения,
	//Гига suv 11.01.2018}
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	&СкладОтправитель                      КАК Склад,
	|
	|	ВЫБОР КОГДА ТаблицаТовары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Обособленно) ТОГДА
	|
	|			ВЫБОР КОГДА ТаблицаТовары.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|				ИЛИ (&ОбосабливатьПоНазначениюЗаказа
	|					И ТаблицаТовары.Назначение.ТипНазначения = ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.Собственное)) ТОГДА
	|					&Назначение
	|				ИНАЧЕ
	|					ТаблицаТовары.Назначение
	|			КОНЕЦ
	|
	|		КОНЕЦ                                            КАК Назначение,
	|
	|	ВЫБОР КОГДА ТаблицаТовары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ИзЗаказов) ТОГДА
	|			ТаблицаТовары.Количество
	|		КОНЕЦ                                            КАК КоличествоИзЗаказов,
	|
	|	ВЫБОР КОГДА ТаблицаТовары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Обособленно) ТОГДА
	|				ТаблицаТовары.Количество
	|		КОНЕЦ                                            КАК КоличествоПодЗаказ,
	|
	|	ВЫБОР КОГДА ТаблицаТовары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Требуется) ТОГДА
	|			ТаблицаТовары.Количество
	|		КОНЕЦ                                            КАК КоличествоНеобеспечено
	|
	|ИЗ
	|	Документ.ЗаказНаПеремещение.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И НЕ ТаблицаТовары.Отменено
	|
	|	И ТаблицаТовары.ВариантОбеспечения В(
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Требуется),
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ИзЗаказов),
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Обособленно))";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

&После("ДобавитьКомандыОтчетов")
Процедура Рин1_ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры)
	Отчеты.Рин1_СредняяСебестоимостьТоваров.ДобавитьКомандуОтчета(КомандыОтчетов);
КонецПроцедуры


