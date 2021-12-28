﻿
&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьНаСервере(Период.ДатаНачала,Период.ДатаОкончания);	
	//СписокДокументов.Загрузить(тзСписокДокументов);
//{{20201130 ГлазуновДВ
	Для Каждого Строка Из СписокДокументов Цикл
		Если Строка.СтатусДокумента = 1 Тогда
			Строка.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакФлажок;
		КонецЕсли;
		Если Строка.СтатусДокумента = 2 Тогда
			Строка.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакКрест;
		КонецЕсли;
		Если Строка.СтатусДокумента = 3 Тогда
			Строка.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакВоcклицательныйЗнак;
		КонецЕсли;
	КонецЦикла;
//}}20201130 ГлазуновДВ
	
КонецПроцедуры

&НаСервере
Функция ОбновитьНаСервере(пДатаНачала, пДатаОкончания)
	//УстановитьОтключениеБезопасногоРежима(Истина);
	//Если БезопасныйРежим() Тогда
	//Сообщить("Работать нельзя безопасно")
	//Иначе
	//Сообщить("Работать можно безопасно")
	//КонецЕсли;
	//
	УстановитьПривилегированныйРежим(Истина);
	//Если ПривилегированныйРежим() Тогда
	//Сообщить("Работать можно")
	//Иначе
	//Сообщить("Работать нельзя")
	//КонецЕсли;
	
	ОтборПартнер = ?(Партнер = Справочники.Партнеры.ПустаяСсылка(),Неопределено,Партнер);
	ОтборКонтрагент = ?(Контрагент = Справочники.Контрагенты.ПустаяСсылка(),Неопределено,Контрагент);
	ОтборМенеджер = ?(Менеджер = Справочники.Пользователи.ПустаяСсылка(),Неопределено,Менеджер);

	ОтборОригиналПолучен = Неопределено;
	Если ОтборОригинал Тогда
		Если ОригиналПолучен = "0" Тогда
			ОтборОригиналПолучен = Перечисления.ЭтапыПроверкиДокументаВРеглУчете.НеПроверен;
		ИначеЕсли ОригиналПолучен = "1" Тогда 
			ОтборОригиналПолучен = Перечисления.ЭтапыПроверкиДокументаВРеглУчете.Проверен;
		ИначеЕсли ОригиналПолучен = "2" Тогда 
			ОтборОригиналПолучен = Перечисления.ЭтапыПроверкиДокументаВРеглУчете.КПовторнойПроверке
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Текст = "ВЫБРАТЬ
	        |	СтатусыПроверкиДокументов.Документ КАК ДокументСсылка,
	        |	ТИПЗНАЧЕНИЯ(СтатусыПроверкиДокументов.Документ) КАК СписокТипДокумента,
	        |	СтатусыПроверкиДокументов.СтатусПроверки КАК ОригиналПолучен,
	        |	СтатусыПроверкиДокументов.Изменил КАК ИзменилПоследний,
	        |	СтатусыПроверкиДокументов.ДатаИзменения КАК ДатаПоследнегоИзменения,
	        |	ЕСТЬNULL(СтатусыПроверкиДокументов.Документ.Партнер, NULL) КАК Партнер,
	        |	ЕСТЬNULL(СтатусыПроверкиДокументов.Документ.Контрагент, NULL) КАК Контрагент,
	        |	СтатусыПроверкиДокументов.Документ.Дата КАК ДатаДокумента,
	        |	СтатусыПроверкиДокументов.Документ.Номер КАК НомерДокумента,
	        |	СтатусыПроверкиДокументов.Документ.НомерВходящегоДокумента КАК НомерВходящий,
	        |	СтатусыПроверкиДокументов.Документ.ДатаВходящегоДокумента КАК ДатаВходящая,
	        |	СтатусыПроверкиДокументов.Документ.Договор.Менеджер КАК СписокМенеджер,
	        |	СтатусыПроверкиДокументов.Проверил КАК РегистрацияПоследний,
	        |	СтатусыПроверкиДокументов.ДатаПроверки КАК ДатаПоследнейРегистрации,
	        |	СтатусыПроверкиДокументов.Документ.Партнер КАК СписокПартнер,
	        |	СтатусыПроверкиДокументов.Документ.Контрагент КАК СписокКонтрагент,
	        |	СтатусыПроверкиДокументов.Документ.СуммаДокумента КАК СписокСумма,
	        |	СчетФактураВыданный.Ссылка КАК СчетФактураУПД,
	        |	СчетФактураВыданный.Номер КАК СчетФактураНомер,
		//{{20201127 ГлазуновДВ
			|	ВЫБОР
			|		КОГДА СтатусыПроверкиДокументов.Документ.Проведен
			|			ТОГДА 1
			|		ИНАЧЕ ВЫБОР
			|				КОГДА СтатусыПроверкиДокументов.Документ.ПометкаУдаления
			|					ТОГДА 2
			|				ИНАЧЕ 3
			|			КОНЕЦ
			|	КОНЕЦ КАК СтатусДокумента
		//}}20201127 ГлазуновДВ
	        |ИЗ
	        |	РегистрСведений.СтатусыПроверкиДокументов КАК СтатусыПроверкиДокументов
	        |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный КАК СчетФактураВыданный
	        |		ПО СтатусыПроверкиДокументов.Документ = СчетФактураВыданный.ДокументОснование
	        |ГДЕ
	        |	СтатусыПроверкиДокументов.Документ.Дата >= &ДатаНачала
	        |	И СтатусыПроверкиДокументов.Документ.Дата <= &ДатаОкончания";
	
	//Если ОтборПартнер <> Неопределено или ОтборКонтрагент <> Неопределено или ОтборОригиналПолучен <> Неопределено или ТипДокумента <> "" ИЛИ ОтборМенеджер <> Неопределено Тогда
		Если ОтборПартнер <> Неопределено Тогда 
			Текст = Текст + " И ЕСТЬNULL(СтатусыПроверкиДокументов.Документ.Партнер, NULL) = &Партнер";
		КонецЕсли;
		
		Если ОтборКонтрагент <> Неопределено Тогда 
			Текст = Текст + " И ЕСТЬNULL(СтатусыПроверкиДокументов.Документ.Контрагент, NULL) = &Контрагент";
		КонецЕсли;
		
		Если ОтборОригиналПолучен <> Неопределено Тогда
			Текст = Текст + " И СтатусыПроверкиДокументов.СтатусПроверки = &ОригиналПолучен";
		КонецЕсли;
		
		Если ТипДокумента <> "" Тогда
			Текст = Текст + " И ТипЗначения(СтатусыПроверкиДокументов.Документ) = Тип(Документ." + ТипДокумента +")";
			//Текст = Текст + " И ТипЗначения(СвязанныеДокументы.Ссылка) = Тип(Документ.СчетФактураВыданный)";
		КонецЕсли;
		
	//{{20201127 ГлазуновДВ
		Если ПомеченныеНаУдаление Тогда
			Текст = Текст + " И Не СтатусыПроверкиДокументов.Документ.ПометкаУдаления";
		КонецЕсли;
		Если Непроведенные Тогда
			Текст = Текст + " И  СтатусыПроверкиДокументов.Документ.Проведен";
		КонецЕсли;
	//}}20201127 ГлазуновДВ
		
		Если ОтборМенеджер <> Неопределено Тогда 
			Текст = Текст + " И ЕСТЬNULL(СтатусыПроверкиДокументов.Документ.Договор.Менеджер, NULL) = &Менеджер";
		КонецЕсли;
	//КонецЕсли;
//{{20201002 ГлазуновДВ добавили для сортировки к выводы на форму
	Текст = Текст + " УПОРЯДОЧИТЬ ПО СтатусыПроверкиДокументов.Документ.Дата, СтатусыПроверкиДокументов.Документ.Номер";
//}}20201002 ГлазуновДВ
	
	Запрос.Текст  = Текст;
	
	Запрос.УстановитьПараметр("Партнер", ОтборПартнер);
	Запрос.УстановитьПараметр("Контрагент",ОтборКонтрагент);
	Запрос.УстановитьПараметр("ОригиналПолучен",ОтборОригиналПолучен);
	Запрос.УстановитьПараметр("ДатаНачала",пДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания",пДатаОкончания);
	Запрос.УстановитьПараметр("Менеджер",ОтборМенеджер);
	
	СписокДокументов.Загрузить(Запрос.Выполнить().Выгрузить());
	
	//ТипЗнч(РезультатЗагрузка[1].Документссылка)
	//РезультатЗагрузка = Запрос.Выполнить().Выгрузить();
	
	Если Подсистема = 1 Тогда
		ЭтаФорма.Элементы.СписокДокументовНомерВходящий.Видимость = Истина;
		ЭтаФорма.Элементы.СписокДокументовДатаВходящая.Видимость = Истина;
	Иначе
		ЭтаФорма.Элементы.СписокДокументовНомерВходящий.Видимость = Ложь;
		ЭтаФорма.Элементы.СписокДокументовДатаВходящая.Видимость = Ложь;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ОригиналПолученПриИзменении(Элемент)
	ОтборОригинал = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОригиналПолученУстановить(Команда)
	ОригиналПолученУстановитьНаСервере();
//{{20201130 ГлазуновДВ
	Для Каждого Строка Из СписокДокументов Цикл
		Если Строка.СтатусДокумента = 1 Тогда
			Строка.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакФлажок;
		КонецЕсли;
		Если Строка.СтатусДокумента = 2 Тогда
			Строка.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакКрест;
		КонецЕсли;
		Если Строка.СтатусДокумента = 3 Тогда
			Строка.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакВоcклицательныйЗнак;
		КонецЕсли;
	КонецЦикла;
//}}20201130 ГлазуновДВ
	
КонецПроцедуры

&НаСервере
Процедура ОригиналПолученУстановитьНаСервере()
	УстановитьПривилегированныйРежим(Истина);
	МассивДляИзмененияСтатуса = Новый Массив;
	ДанныеОшибок = Новый Соответствие;

	Для Каждого Стр из СписокДокументов Цикл
		Если Стр.Пометка Тогда
			МассивДляИзмененияСтатуса.Добавить(Стр.ДокументСсылка);			
		КонецЕсли;
	КонецЦикла;
	
	ЕстьСвязанныеДок = Ложь;
	
	Если ТипДокумента = "РеализацияТоваровУслуг" Тогда
		СписокСвязанныхДок = ПолучитьСФВыданные(МассивДляИзмененияСтатуса);
		ЕстьСвязанныеДок = Истина;
	ИначеЕсли ТипДокумента = "ПриобретениеТоваровУслуг" Тогда
		СписокСвязанныхДок = ПолучитьСФПолученные(МассивДляИзмененияСтатуса);
		ЕстьСвязанныеДок = Истина;		
	ИначеЕсли ТипДокумента = "СчетФактураВыданный" Тогда
		СписокСвязанныхДок = ПолучитьРеализации(МассивДляИзмененияСтатуса);
		ЕстьСвязанныеДок = Истина;		
	ИначеЕсли ТипДокумента = "СчетФактураПолученный" Тогда
		СписокСвязанныхДок = ПолучитьПриобретения(МассивДляИзмененияСтатуса);
		ЕстьСвязанныеДок = Истина;
	КонецЕсли;

	Если ЕстьСвязанныеДок Тогда 
		Для Каждого Стр из СписокСвязанныхДок Цикл 
			МассивДляИзмененияСтатуса.Добавить(Стр.ДокументСсылка);
		КонецЦикла;
    КонецЕсли;
		
	РегистрыСведений.СтатусыПроверкиДокументов.УстановитьСтатусПроверкиДокументов(МассивДляИзмененияСтатуса,ДанныеОшибок,Истина);
	ОбновитьНаСервере(Период.ДатаНачала,Период.ДатаОкончания);
КонецПроцедуры

&НаСервере
Функция ПолучитьСФВыданные(МассивДляИзмененияСтатуса)
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СчетФактураВыданныйДокументыОснования.Ссылка КАК ДокументСсылка
	                      |ИЗ
	                      |	Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования
	                      |ГДЕ
	                      |	СчетФактураВыданныйДокументыОснования.Ссылка.Проведен
	                      |	И СчетФактураВыданныйДокументыОснования.ДокументОснование В(&Ссылка)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	СчетФактураВыданныйДокументыОснования.Ссылка");
	Запрос.УстановитьПараметр("Ссылка",МассивДляИзмененияСтатуса);
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
Функция ПолучитьСФПолученные(МассивДляИзмененияСтатуса)
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СчетФактураПолученныйДокументыОснования.Ссылка КАК ДокументСсылка
	                      |ИЗ
	                      |	Документ.СчетФактураПолученный.ДокументыОснования КАК СчетФактураПолученныйДокументыОснования
	                      |ГДЕ
	                      |	СчетФактураПолученныйДокументыОснования.Ссылка.Проведен
	                      |	И СчетФактураПолученныйДокументыОснования.ДокументОснование В(&Ссылка)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	СчетФактураПолученныйДокументыОснования.Ссылка");
	Запрос.УстановитьПараметр("Ссылка",МассивДляИзмененияСтатуса);
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
Функция ПолучитьРеализации(МассивДляИзмененияСтатуса)
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СчетФактураВыданныйДокументыОснования.ДокументОснование КАК ДокументСсылка
	                      |ИЗ
	                      |	Документ.СчетФактураВыданный.ДокументыОснования КАК СчетФактураВыданныйДокументыОснования
	                      |ГДЕ
	                      |	СчетФактураВыданныйДокументыОснования.Ссылка В(&Ссылка)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	СчетФактураВыданныйДокументыОснования.ДокументОснование");
	Запрос.УстановитьПараметр("Ссылка",МассивДляИзмененияСтатуса);
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
Функция ПолучитьПриобретения(МассивДляИзмененияСтатуса)
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СчетФактураПолученныйДокументыОснования.ДокументОснование КАК ДокументСсылка
	                      |ИЗ
	                      |	Документ.СчетФактураПолученный.ДокументыОснования КАК СчетФактураПолученныйДокументыОснования
	                      |ГДЕ
	                      |	СчетФактураПолученныйДокументыОснования.Ссылка В(&Ссылка)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	СчетФактураПолученныйДокументыОснования.ДокументОснование");
	Запрос.УстановитьПараметр("Ссылка",МассивДляИзмененияСтатуса);
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаКлиенте
Процедура УстановитьПометку(Команда)
//ГлазуновДВ Поменяли процесс выделения строк для Регистрации	
	Для Каждого Стр из СписокДокументов Цикл 
	//	Стр.Пометка = Истина;
		Стр.Пометка = Ложь;
	КонецЦикла;
	Для Каждого Стр из Элементы.СписокДокументов.ВыделенныеСтроки Цикл 
			СтрокаСписка = СписокДокументов.НайтиПоИдентификатору(Стр);
			СтрокаСписка.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометку(Команда)
	Для Каждого Стр из СписокДокументов Цикл 
		Стр.Пометка = Ложь;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	//Если ПривилегированныйРежим() Тогда
	//Сообщить("Работать можно")
	//Иначе
	//Сообщить("Работать нельзя")
	//КонецЕсли;
	Подсистема = 0;
	ЗаполнитьСписокПродажи();			
	ТипДокумента = "РеализацияТоваровУслуг";
	Период.ДатаНачала = НачалоМесяца(ТекущаяДата());
	Период.ДатаОкончания = КонецМесяца(Период.ДатаНачала);
	
//	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсистемаПриИзменении(Элемент)
	Если Подсистема = 0 Тогда
		ЗаполнитьСписокПродажи();
		СписокДокументов.Очистить();
	ИначеЕсли Подсистема = 1 Тогда
		ЗаполнитьСписокЗакупки();
		СписокДокументов.Очистить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПродажи()
	УстановитьПривилегированныйРежим(Истина);
	    Элементы.ТипДокумента.СписокВыбора.Очистить();
	 	Элементы.ТипДокумента.СписокВыбора.Добавить("АктВыполненныхРабот","Акт выполненных работ для клиента");
		Элементы.ТипДокумента.СписокВыбора.Добавить("АктОРасхожденияхПослеОтгрузки","Акт о расхождениях после отгрузки");
		//Элементы.ТипДокумента.СписокВыбора.Добавить("АктОРасхожденияхПослеПриемки","Акт о расхождениях после приемки");
		Элементы.ТипДокумента.СписокВыбора.Добавить("ВозвратТоваровОтКлиента","Возврат товаров от клиента");
		Элементы.ТипДокумента.СписокВыбора.Добавить("КорректировкаРеализации","Корректировка реализации");
		Элементы.ТипДокумента.СписокВыбора.Добавить("РеализацияТоваровУслуг","Реализация товаров и услуг");
		Элементы.ТипДокумента.СписокВыбора.Добавить("РеализацияУслугПрочихАктивов","Реализация услуг и прочих активов");
		Элементы.ТипДокумента.СписокВыбора.Добавить("СчетФактураВыданный","Счет-фактура выданный");
        ТипДокумента = "РеализацияТоваровУслуг";
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЗакупки()
	УстановитьПривилегированныйРежим(Истина);
	    Элементы.ТипДокумента.СписокВыбора.Очистить();
		Элементы.ТипДокумента.СписокВыбора.Добавить("АктОРасхожденияхПослеПриемки","Акт о расхождениях после приемки");
		Элементы.ТипДокумента.СписокВыбора.Добавить("ВозвратТоваровПоставщику","Возврат товаров поставщику");
		Элементы.ТипДокумента.СписокВыбора.Добавить("КорректировкаПриобретения","Корректировка приобретения");
		Элементы.ТипДокумента.СписокВыбора.Добавить("ПоступлениеТоваровНаСклад","Поступление товаров на склад");
		Элементы.ТипДокумента.СписокВыбора.Добавить("ПриобретениеТоваровУслуг","Приобретение товаров и услуг");
		Элементы.ТипДокумента.СписокВыбора.Добавить("ПриобретениеУслугПрочихАктивов","Приобретение услуг и прочих активов");
		Элементы.ТипДокумента.СписокВыбора.Добавить("ПриобретениеУслугПрочихАктивов","Приобретение услуг и прочих активов");
	    Элементы.ТипДокумента.СписокВыбора.Добавить("СчетФактураПолученный","Счет-фактура полученный");
		Элементы.ТипДокумента.СписокВыбора.Добавить("СчетФактураПолученныйНалоговыйАгент","Счет-фактура полученный (налоговый агент)");
        ТипДокумента = "ПриобретениеТоваровУслуг";
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
			
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Период.ДатаНачала, Период.ДатаОкончания);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Период.ДатаНачала = РезультатВыбора.НачалоПериода;
	Период.ДатаОкончания = РезультатВыбора.КонецПериода;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДокументаПриИзменении(Элемент)
	СписокДокументов.Очистить();
КонецПроцедуры

&НаСервере
Процедура ОригиналПолученСнятьНаСервере()
	УстановитьПривилегированныйРежим(Истина);
	// Вставить содержимое обработчика.
	МассивДляИзмененияСтатуса = Новый Массив;
	ДанныеОшибок = Новый Соответствие;

	Для Каждого Стр из СписокДокументов Цикл
		Если Стр.Пометка Тогда
			МассивДляИзмененияСтатуса.Добавить(Стр.ДокументСсылка);			
		КонецЕсли;
	КонецЦикла;
	
	ЕстьСвязанныеДок = Ложь;
	
	//Если ТипДокумента = "РеализацияТоваровУслуг" Тогда
	//	СписокСвязанныхДок = ПолучитьСФВыданные(МассивДляИзмененияСтатуса);
	//	ЕстьСвязанныеДок = Истина;
	//ИначеЕсли ТипДокумента = "ПриобретениеТоваровУслуг" Тогда
	//	СписокСвязанныхДок = ПолучитьСФПолученные(МассивДляИзмененияСтатуса);
	//	ЕстьСвязанныеДок = Истина;		
	//ИначеЕсли ТипДокумента = "СчетФактураВыданный" Тогда
	//	СписокСвязанныхДок = ПолучитьРеализации(МассивДляИзмененияСтатуса);
	//	ЕстьСвязанныеДок = Истина;		
	//ИначеЕсли ТипДокумента = "СчетФактураПолученный" Тогда
	//	СписокСвязанныхДок = ПолучитьПриобретения(МассивДляИзмененияСтатуса);
	//	ЕстьСвязанныеДок = Истина;
	//КонецЕсли;

	//Если ЕстьСвязанныеДок Тогда 
	//	Для Каждого Стр из СписокСвязанныхДок Цикл 
	//		МассивДляИзмененияСтатуса.Добавить(Стр.ДокументСсылка);
	//	КонецЦикла;
	//КонецЕсли;
		
	РегистрыСведений.СтатусыПроверкиДокументов.УстановитьСтатусПроверкиДокументов(МассивДляИзмененияСтатуса, ДанныеОшибок, Ложь);
	//РегистрыСведений.СтатусыПроверкиДокументов.УстановитьСтатусПроверкиДокументов(МассивДляИзмененияСтатуса,ДанныеОшибок,Истина);
	ОбновитьНаСервере(Период.ДатаНачала,Период.ДатаОкончания);
КонецПроцедуры

&НаКлиенте
Процедура ОригиналПолученСнять(Команда)
	ОригиналПолученСнятьНаСервере();
//{{20201130 ГлазуновДВ
	Для Каждого Строка Из СписокДокументов Цикл
		Если Строка.СтатусДокумента = 1 Тогда
			Строка.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакФлажок;
		КонецЕсли;
		Если Строка.СтатусДокумента = 2 Тогда
			Строка.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакКрест;
		КонецЕсли;
		Если Строка.СтатусДокумента = 3 Тогда
			Строка.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакВоcклицательныйЗнак;
		КонецЕсли;
	КонецЦикла;
//}}20201130 ГлазуновДВ
	
КонецПроцедуры

&НаСервере
Процедура СписокДокументовВыборНаСервере(СслыкаЭлемента)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	Если Не (Поле.Заголовок = "" Или Поле.Заголовок = "Номер Сч-Фактуры") Тогда
		//СслыкаЭлемента = Элемент.ТекущиеДанные.ДокументСсылка;
		//СписокДокументовВыборНаСервере(СслыкаЭлемента);
		ОткрытьЗначение(Элемент.ТекущиеДанные.ДокументСсылка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	// Вставить содержимое обработчика.
//	УстановитьОтключениеБезопасногоРежима(Истина);
	//Если БезопасныйРежим() Тогда
	//Сообщить("Работать нельзя безопасно")
	//Иначе
	//Сообщить("Работать можно безопасно")
	//КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	//Если ПривилегированныйРежим() Тогда
	//Сообщить("Работать можно")
	//Иначе
	//Сообщить("Работать нельзя")
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	// Вставить содержимое обработчика.
//	УстановитьОтключениеБезопасногоРежима(Истина);
//	УстановитьПривилегированныйРежим(Истина);
//	УстановитьПривилегированныйРежим(Ложь);
	//Если ПривилегированныйРежим() Тогда
	//Сообщить("Работать можно")
	//Иначе
	//Сообщить("Работать нельзя")
	//КонецЕсли;
//	УстановитьОтключениеБезопасногоРежима(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
//	ПриЗакрытииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОтборОригиналПриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

//{{20201130 ГлазуновДВ Установка картинок, по проведен, не проведен, помечен на удаление
&НаСервере
Процедура УстановитьУсловноеОформление()
	
	//УсловноеОформление.Элементы.Очистить();
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДокументовСтатусДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокДокументов.СтатусДокумента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "Пр.");
	//Элемент.Оформление.УстановитьЗначениеПараметра("Картинка", БиблиотекаКартинок.Провести);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДокументовСтатусДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокДокументов.СтатусДокумента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 2;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "Уд.");
	//Элемент.Оформление.УстановитьЗначениеПараметра("Картинка", БиблиотекаКартинок.ПомеченныйНаУдалениеЭлемент);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДокументовСтатусДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокДокументов.СтатусДокумента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 3;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "");
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	// Вставить содержимое обработчика.
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Если Элемент.ТекущиеДанные.СтатусДокумента = 1 Тогда
			Элемент.ТекущиеДанные.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакФлажок;
		КонецЕсли;
		Если Элемент.ТекущиеДанные.СтатусДокумента = 2 Тогда
			Элемент.ТекущиеДанные.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакКрест;
		КонецЕсли;
		Если Элемент.ТекущиеДанные.СтатусДокумента = 3 Тогда
			Элемент.ТекущиеДанные.СтандартнаяКартинка = БиблиотекаКартинок.ОформлениеЗнакВоcклицательныйЗнак;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
//}}20201130 ГлазуновДВ

//Остался вопрос по выводу связанных документов!!! ГлазуновДВ
	//	Запрос.Текст = "ВЫБРАТЬ
	//	|	СвязанныеДокументы.Ссылка
	//	|ИЗ
	//	|	КритерийОтбора.СвязанныеДокументы(&ЗначениеКритерияОтбора) КАК СвязанныеДокументы";
	//	
	//КонецЕсли;
	//
	//Запрос.УстановитьПараметр("ЗначениеКритерияОтбора", ЗначениеКритерияОтбора);

//ВЫБРАТЬ РАЗРЕШЕННЫЕ * ИЗ ( ВЫБРАТЬ 
//Дата           КАК Дата,
//	Ссылка,
//Проведен       КАК Проведен,
//	ПометкаУдаления,
//NULL КАК СуммаДокумента,
//Валюта         КАК Валюта,
//	Представление КАК Представление,
//	NULL Как ДополнительныйРеквизит1,
//	NULL Как ДополнительныйРеквизит2,
//	NULL Как ДополнительныйРеквизит3
//ИЗ
//	Документ.СчетФактураВыданный
//ГДЕ
//	Ссылка В (&СчетФактураВыданный)) КАК ПодчиненныеОбъекты УПОРЯДОЧИТЬ ПО ПодчиненныеОбъекты.Дата
