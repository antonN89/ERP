﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь; 
	Настройки =  КомпоновщикНастроек.ПолучитьНастройки(); 
	
	
	ПараметрыЗапроса = Новый Структура;
	
	ПараметрыЗапроса.Вставить("Период", ТекущаяДата());
	ПараметрыЗапроса.Вставить("Валюта", Справочники.Валюты.ПустаяСсылка());
	ПараметрыЗапроса.Вставить("ВариантКлассификацииЗадолженности", Справочники.ВариантыКлассификацииЗадолженности.ПустаяСсылка());
	ПараметрыЗапроса.Вставить("ВключатьЗадолженность", 1);
	ПараметрыЗапроса.Вставить("ДатаОтчета", ТекущаяДата());
	ПараметрыЗапроса.Вставить("ДатаОтчетаГраница", ТекущаяДата());
	ПараметрыЗапроса.Вставить("ИспользуетсяОтборПоСегментуПартнеров", Ложь);
	ПараметрыЗапроса.Вставить("Календарь", Справочники.ПроизводственныеКалендари.НайтиПоКоду("РФ"));
	ПараметрыЗапроса.Вставить("СтрокаДолгНеПросрочен", "");
	ПараметрыЗапроса.Вставить("СтрокаСостояниеВзаиморасчетов", "");
	
	ТаблицаДанных = ОбщегоНазначенияУТ.ЗапросВыполнитьВыгрузить(ТекстЗапросаДЗ(),ПараметрыЗапроса);
	
	Если Настройки.ПараметрыДанных.Элементы.Количество() > 0 И Настройки.ПараметрыДанных.Элементы[0].Использование = Истина И Настройки.ПараметрыДанных.Элементы[0].Значение = Истина Тогда
		
		Для Каждого ЭлементТаблицы Из ТаблицаДанных Цикл 
			
			ЭлементТаблицы.Обсуждения = ПолучитьПоследниеОбсуждения(ЭлементТаблицы.Договор);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ВнешниеНаборыДанных = Новый Структура;
    ВнешниеНаборыДанных.Вставить("ТаблицаДанных",ТаблицаДанных);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;	 
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);	 
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	ДокументРезультат.Очистить(); 
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;  
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);  
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры


Функция ПолучитьПоследниеОбсуждения(Договор)
	
	ТекстОбсуждений = "";
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("Договор",Договор);
	
	ТаблицаОбсуждений = ОбщегоНазначенияУТ.ЗапросВыполнитьВыгрузить(ТекстЗапросаОбсуждений(),ПараметрыЗапроса);
	
	Если ТаблицаОбсуждений.Количество() > 0 Тогда
		
		Для Каждого ЭлементТаблицы Из ТаблицаОбсуждений Цикл 
			
			ТекстОбсуждений = ТекстОбсуждений + ЭлементТаблицы.Обсуждение + Символы.ПС; 
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТекстОбсуждений;
	
КонецФункции

Функция ТекстЗапросаОбсуждений()
	
	Возврат "ВЫБРАТЬ ПЕРВЫЕ 3
	|	РИНЭКО_ИсторияОбсуждений.Сообщение КАК Обсуждение
	|ИЗ
	|	РегистрСведений.РИНЭКО_ИсторияОбсуждений КАК РИНЭКО_ИсторияОбсуждений
	|ГДЕ
	|	РИНЭКО_ИсторияОбсуждений.Договор = &Договор
	|
	|УПОРЯДОЧИТЬ ПО
	|	РИНЭКО_ИсторияОбсуждений.Период УБЫВ";
	
КонецФункции

Функция ТекстЗапросаДЗ()
	
	Возврат "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Сегменты.Партнер КАК Партнер,
	|	ИСТИНА КАК ИспользуетсяОтборПоСегментуПартнеров
	|ПОМЕСТИТЬ ОтборПоСегментуПартнеров
	|ИЗ
	|	РегистрСведений.ПартнерыСегмента КАК Сегменты
	|{ГДЕ
	|	Сегменты.Сегмент.* КАК СегментПартнеров,
	|	Сегменты.Партнер.* КАК Партнер}
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер,
	|	ИспользуетсяОтборПоСегментуПартнеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КурсВалюты.Валюта КАК Валюта,
	|	КурсВалюты.Курс * КурсВалютыОтчета.Кратность / (КурсВалюты.Кратность * КурсВалютыОтчета.Курс) КАК Коэффициент
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних({(&ДатаОтчета)}, ) КАК КурсВалюты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних({(&ДатаОтчета)}, Валюта = &Валюта) КАК КурсВалютыОтчета
	|		ПО (ИСТИНА)
	|ГДЕ
	|	КурсВалюты.Кратность <> 0
	|	И КурсВалютыОтчета.Курс <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АналитикаУчета.Организация КАК Организация,
	|	АналитикаУчета.Партнер КАК Партнер,
	|	АналитикаУчета.Контрагент КАК Контрагент,
	|	АналитикаУчета.Договор КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	РасчетыПоСрокам.ОбъектРасчетов КАК ОбъектРасчетов,
	|	РасчетыПоСрокам.Валюта КАК Валюта,
	|	РасчетыПоСрокам.РасчетныйДокумент КАК РасчетныйДокумент,
	|	РасчетыПоСрокам.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
	|	РасчетыПоСрокам.ДатаВозникновения КАК ДатаВозникновения,
	|	РасчетыПоСрокам.ПредоплатаРеглОстаток КАК НашДолг,
	|	РасчетыПоСрокам.ДолгРеглОстаток КАК ДолгКлиента,
	|	ВЫБОР
	|		КОГДА РасчетыПоСрокам.ДатаПлановогоПогашения < НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	|			ТОГДА РасчетыПоСрокам.ДолгРеглОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ДолгКлиентаПросрочено,
	|	0 КАК КОтгрузке
	|ПОМЕСТИТЬ ТаблицаЗадолженностей
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоСрокам.Остатки(&ДатаОтчетаГраница, ) КАК РасчетыПоСрокам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|		ПО РасчетыПоСрокам.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|ГДЕ
	|	АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	И (&ВключатьЗадолженность = 0
	|			ИЛИ &ВключатьЗадолженность = 1)
	|{ГДЕ
	|	АналитикаУчета.Организация.* КАК Организация,
	|	АналитикаУчета.Партнер.* КАК Партнер,
	|	АналитикаУчета.Контрагент.* КАК Контрагент,
	|	АналитикаУчета.Договор.* КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|	(АналитикаУчета.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров)) КАК Поле2}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АналитикаУчета.Организация,
	|	АналитикаУчета.Партнер,
	|	АналитикаУчета.Контрагент,
	|	АналитикаУчета.Договор,
	|	АналитикаУчета.НаправлениеДеятельности,
	|	РасчетыПланОплат.ОбъектРасчетов,
	|	РасчетыПланОплат.Валюта,
	|	РасчетыПланОплат.ДокументПлан,
	|	РасчетыПланОплат.ДатаПлановогоПогашения,
	|	РасчетыПланОплат.ДатаВозникновения,
	|	0,
	|	РасчетыПланОплат.КОплатеОстаток * ЕСТЬNULL(Курсы.Коэффициент, 1),
	|	ВЫБОР
	|		КОГДА РасчетыПланОплат.ДатаПлановогоПогашения < НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	|			ТОГДА РасчетыПланОплат.КОплатеОстаток * ЕСТЬNULL(Курсы.Коэффициент, 1)
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	0
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПланОплат.Остатки(&ДатаОтчетаГраница, ) КАК РасчетыПланОплат
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|		ПО РасчетыПланОплат.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК Курсы
	|		ПО (Курсы.Валюта = РасчетыПланОплат.Валюта)
	|ГДЕ
	|	АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	И (&ВключатьЗадолженность = 0
	|			ИЛИ &ВключатьЗадолженность = 2)
	|{ГДЕ
	|	АналитикаУчета.Организация.* КАК Организация,
	|	АналитикаУчета.Партнер.* КАК Партнер,
	|	АналитикаУчета.Контрагент.* КАК Контрагент,
	|	АналитикаУчета.Договор.* КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|	(АналитикаУчета.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров)) КАК Поле2}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АналитикаУчета.Организация,
	|	АналитикаУчета.Партнер,
	|	АналитикаУчета.Контрагент,
	|	АналитикаУчета.Договор,
	|	АналитикаУчета.НаправлениеДеятельности,
	|	РасчетыПланОтгрузок.ОбъектРасчетов,
	|	РасчетыПланОтгрузок.Валюта,
	|	РасчетыПланОтгрузок.ДокументПлан,
	|	РасчетыПланОтгрузок.ДатаПлановогоПогашения,
	|	РасчетыПланОтгрузок.ДатаВозникновения,
	|	0,
	|	0,
	|	0,
	|	РасчетыПланОтгрузок.СуммаОстаток * ЕСТЬNULL(Курсы.Коэффициент, 1)
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПланОтгрузок.Остатки(&ДатаОтчетаГраница, ) КАК РасчетыПланОтгрузок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|		ПО РасчетыПланОтгрузок.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК Курсы
	|		ПО (Курсы.Валюта = РасчетыПланОтгрузок.Валюта)
	|ГДЕ
	|	АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|	И (&ВключатьЗадолженность = 0
	|			ИЛИ &ВключатьЗадолженность = 2)
	|{ГДЕ
	|	АналитикаУчета.Организация.* КАК Организация,
	|	АналитикаУчета.Партнер.* КАК Партнер,
	|	АналитикаУчета.Контрагент.* КАК Контрагент,
	|	АналитикаУчета.Договор.* КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|	(АналитикаУчета.Партнер В
	|			(ВЫБРАТЬ
	|				ОтборПоСегментуПартнеров.Партнер
	|			ИЗ
	|				ОтборПоСегментуПартнеров
	|			ГДЕ
	|				ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров)) КАК Поле2}
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаЗадолженностей.ДатаПлановогоПогашения КАК ДатаНачала,
	|	ГрафикиРаботы.Дата КАК ДатаОкончания,
	|	ВЫБОР
	|		КОГДА ГрафикиРаботы.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
	|				ИЛИ ГрафикиРаботы.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РабочийДень
	|ПОМЕСТИТЬ Графики
	|ИЗ
	|	ТаблицаЗадолженностей КАК ТаблицаЗадолженностей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ГрафикиРаботы
	|		ПО (ГрафикиРаботы.ПроизводственныйКалендарь = &Календарь)
	|ГДЕ
	|	ГрафикиРаботы.Дата МЕЖДУ ТаблицаЗадолженностей.ДатаПлановогоПогашения И &ДатаОтчета
	|	И ТаблицаЗадолженностей.ДатаПлановогоПогашения <> ДАТАВРЕМЯ(1, 1, 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.ДатаНачала КАК ДатаНачала,
	|	ВложенныйЗапрос.ДатаОкончания КАК ДатаОкончания,
	|	ЕСТЬNULL(СУММА(Графики.РабочийДень), 0) КАК КоличествоДней
	|ПОМЕСТИТЬ РазностиДат
	|ИЗ
	|	Графики КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Графики КАК Графики
	|		ПО ВложенныйЗапрос.ДатаНачала = Графики.ДатаНачала
	|			И ВложенныйЗапрос.ДатаОкончания > Графики.ДатаОкончания
	|ГДЕ
	|	ВложенныйЗапрос.ДатаОкончания = НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.ДатаНачала,
	|	ВложенныйЗапрос.ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&СтрокаСостояниеВзаиморасчетов КАК ГруппировкаВсего,
	|	ТаблицаЗадолженностей.Организация КАК Организация,
	|	ТаблицаЗадолженностей.Партнер КАК Партнер,
	|	ТаблицаЗадолженностей.Контрагент КАК Контрагент,
	|	ТаблицаЗадолженностей.Договор КАК Договор,
	|	ТаблицаЗадолженностей.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаЗадолженностей.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ТаблицаЗадолженностей.Валюта КАК Валюта,
	|	ТаблицаЗадолженностей.РасчетныйДокумент КАК РасчетныйДокумент,
	|	ТаблицаЗадолженностей.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
	|	ТаблицаЗадолженностей.ДатаВозникновения КАК ДатаВозникновения,
	|	ТаблицаЗадолженностей.НашДолг КАК НашДолг,
	|	ТаблицаЗадолженностей.ДолгКлиента КАК ДолгКлиента,
	|	ТаблицаЗадолженностей.ДолгКлиентаПросрочено КАК ДолгКлиентаПросрочено,
	|	ТаблицаЗадолженностей.КОтгрузке КАК КОтгрузке,
	|	ВЫБОР
	|		КОГДА НЕ РазностиДат.КоличествоДней ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА РазностиДат.КоличествоДней > 0
	|						ТОГДА РазностиДат.КоличествоДней
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ТаблицаЗадолженностей.ДолгКлиента = 0
	|						ИЛИ ТаблицаЗадолженностей.ДатаПлановогоПогашения = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА 0
	|				ИНАЧЕ ВЫБОР
	|						КОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ) > 0
	|							ТОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ)
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК КоличествоДней,
	|	ЕСТЬNULL(Интервалы.НаименованиеИнтервала, &СтрокаДолгНеПросрочен) КАК НаименованиеИнтервала,
	|	ЕСТЬNULL(Интервалы.НомерСтроки, 0) КАК НомерИнтервала,
	|	ЕСТЬNULL(Интервалы.НижняяГраницаИнтервала, 0) КАК НижняяГраницаИнтервала,
	|	ТаблицаЗадолженностей.Договор.РИНЭКО_СтатусДЗ КАК ДоговорРИНЭКО_СтатусДЗ,
	|	ТаблицаЗадолженностей.ОбъектРасчетов.Подразделение КАК ОбъектРасчетовПодразделение,
	|	ТаблицаЗадолженностей.ОбъектРасчетов.Менеджер КАК ОбъектРасчетовМенеджер,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(300)) КАК Обсуждения
	|ИЗ
	|	ТаблицаЗадолженностей КАК ТаблицаЗадолженностей
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РазностиДат КАК РазностиДат
	|		ПО (РазностиДат.ДатаНачала = ТаблицаЗадолженностей.ДатаПлановогоПогашения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКлассификацииЗадолженности.Интервалы КАК Интервалы
	|		ПО (Интервалы.Ссылка = &ВариантКлассификацииЗадолженности)
	|			И (ВЫБОР
	|				КОГДА НЕ РазностиДат.КоличествоДней ЕСТЬ NULL
	|					ТОГДА ВЫБОР
	|							КОГДА РазностиДат.КоличествоДней > 0
	|								ТОГДА РазностиДат.КоличествоДней
	|							ИНАЧЕ 0
	|						КОНЕЦ
	|				ИНАЧЕ ВЫБОР
	|						КОГДА ТаблицаЗадолженностей.ДолгКлиента = 0
	|								ИЛИ ТаблицаЗадолженностей.ДатаПлановогоПогашения = ДАТАВРЕМЯ(1, 1, 1)
	|							ТОГДА 0
	|						ИНАЧЕ ВЫБОР
	|								КОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ) > 0
	|									ТОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ)
	|								ИНАЧЕ 0
	|							КОНЕЦ
	|					КОНЕЦ
	|			КОНЕЦ МЕЖДУ Интервалы.НижняяГраницаИнтервала И Интервалы.ВерхняяГраницаИнтервала)}";
	
КонецФункции