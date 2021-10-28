﻿
&НаСервере
Процедура Рин1_ПриСозданииНаСервереВместо(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ОткрытаПоСценарию") Тогда
		ВызватьИсключение НСтр("ru = 'Обработка не предназначена для непосредственного использования.';
								|en = 'This data processor is not intended for manual use.'");
	КонецЕсли;
	
	// Настройки формы
	СведенияОАдресномКлассификаторе = УправлениеКонтактнойИнформациейСлужебныйПовтИсп.СведенияОДоступностиАдресногоКлассификатора();
	ЕстьЗагруженныйКлассификатор      = СведенияОАдресномКлассификаторе.Получить("ИспользоватьЗагруженные");
	ВебКлассификаторДоступен          = СведенияОАдресномКлассификаторе.Получить("КлассификаторДоступен");
	ИспользуетсяАдресныйКлассификатор = СведенияОАдресномКлассификаторе.Получить("ИспользуетсяАдресныйКлассификатор");
	ВебСервисИспользуется           = ВебКлассификаторДоступен;
	
	Если Не ИспользуетсяАдресныйКлассификатор Тогда
		ОтключитьВозможностьВыбораАдресныхСведенийИзКлассификатора();
	КонецЕсли;
	
	ЕстьПравоЗагружатьКлассификатор = Обработки.РасширенныйВводКонтактнойИнформации.ЕстьВозможностьИзмененияАдресногоКлассификатора();
	
	Параметры.Свойство("ВозвращатьСписокЗначений", ВозвращатьСписокЗначений);
	
	ОсновнаяСтрана           = РаботаСАдресамиКлиентСервер.ОсновнаяСтрана();
	ВидКИ = УправлениеКонтактнойИнформациейСлужебный.СтруктураВидаКонтактнойИнформации(Параметры.ВидКонтактнойИнформации);
	ВидКонтактнойИнформации = ВидКИ;
	ПриСозданииНаСервереХранитьИсториюИзменений();
	
	Заголовок = ?(ПустаяСтрока(Параметры.Заголовок), Строка(ВидКИ.Ссылка), Параметры.Заголовок);
	
	СкрыватьНеактуальныеАдреса  = ВидКонтактнойИнформации.СкрыватьНеактуальныеАдреса;
	ТолькоНациональныйАдрес     = ВидКонтактнойИнформации.ТолькоНациональныйАдрес;
	ТипКонтактнойИнформации     = ВидКонтактнойИнформации.Тип;
	МеждународныйФорматАдреса   = ВидКонтактнойИнформации.МеждународныйФорматАдреса;
	
	Элементы.АдресВСвободнойФорме.Видимость                                         = Не ВидКонтактнойИнформации.ПроверятьКорректность;
	Элементы.ПредставлениеАдресаКонтекстноеМенюВвестиАдресВСвободнойФорме.Видимость = Не ВидКонтактнойИнформации.ПроверятьКорректность;
	
	// Пытаемся заполнить из параметров.
	ЗначенияПолей = ОпределитьЗначениеАдреса(Параметры);
	
	Если ПустаяСтрока(ЗначенияПолей) Тогда
		НаселенныйПунктДетально = УправлениеКонтактнойИнформацией.ОписаниеНовойКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес); // Новый адрес
		//bercut 020720 Задача № 1521
		//НаселенныйПунктДетально.AddressType = РаботаСАдресамиКлиентСервер.МуниципальныйАдрес();
		НаселенныйПунктДетально.AddressType = РаботаСАдресамиКлиентСервер.АдминистративноТерриториальныйАдрес();
		//
	ИначеЕсли УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВJSON(ЗначенияПолей) Тогда
		ДанныеАдреса = УправлениеКонтактнойИнформациейСлужебный.JSONВКонтактнуюИнформациюПоПолям(ЗначенияПолей, Перечисления.ТипыКонтактнойИнформации.Адрес);
		НаселенныйПунктДетально = РаботаСАдресами.ПодготовитьАдресДляВвода(ДанныеАдреса);
	Иначе
		XDTOКонтактная = ИзвлечьСтарыйФорматАдреса(ЗначенияПолей, ТипКонтактнойИнформации);
		ДанныеАдреса = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияВСтруктуруJSON(XDTOКонтактная, ТипКонтактнойИнформации);
		НаселенныйПунктДетально = РаботаСАдресами.ПодготовитьАдресДляВвода(ДанныеАдреса);
	КонецЕсли;
	
	Если МеждународныйФорматАдреса И Не УправлениеКонтактнойИнформациейКлиентСервер.ЭтоАдресВСвободнойФорме(НаселенныйПунктДетально.AddressType) Тогда
		НаселенныйПунктДетально.AddressType = УправлениеКонтактнойИнформациейКлиентСервер.ИностранныйАдрес();
	ИначеЕсли ЗначениеЗаполнено(Параметры.ТипАдреса) Тогда
		УстановитьТипАдресаИзПараметра(Параметры.ТипАдреса);
	КонецЕсли;
	
	ЗаполнитьПредопределенныеВариантыАдреса(Параметры);
	
	УстановитьЗначениеРеквизитовПоКонтактнойИнформации(НаселенныйПунктДетально);
	
	Если ЗначениеЗаполнено(НаселенныйПунктДетально.Comment) Тогда
		Элементы.ОсновныеСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Комментарий);
	Иначе
		Элементы.ОсновныеСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Если ТолькоНациональныйАдрес Тогда
		
		Элементы.Страна.Видимость = Ложь;
		Элементы.ОКТМО.Видимость  = ВидКонтактнойИнформации.УказыватьОКТМО;
		
		Если Страна <> ОсновнаяСтрана Тогда
			
			// Считаем адрес российским
			ТекстПредупрежденияПриОткрытии = НСтр("ru = 'Адрес введен некорректно: допускается ввод только национальных адресов.
			|Значение поля ""Страна"" было изменено на %1, необходимо проверить остальные поля.';
			|en = 'Address is invalid. You can enter only national addresses.
			|Country value was changed to %1. Please check other fields.'");
			ТекстПредупрежденияПриОткрытии = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупрежденияПриОткрытии, ОсновнаяСтрана.Наименование);
			ПолеПредупрежденияПриОткрытии               = "СтранаВСвободнойФорме";
			Модифицированность                          = Истина;
			Элементы.Страна.Доступность                 = Ложь;
			Элементы.Страна.Видимость                   = Истина;
			Элементы.СтранаВСвободнойФорме.Видимость    = Истина;
			Элементы.СтранаВСвободнойФорме.КнопкаВыбора = Ложь;
			Элементы.СтранаВСвободнойФорме.Доступность  = Ложь;
		
		КонецЕсли;
		
		Если СтрНачинаетсяС(ВРег(НаселенныйПунктДетально.value), ВРег(НаселенныйПунктДетально.country) + ",") Тогда
			ЧастиАдреса                   = СтрРазделить(НаселенныйПунктДетально.value, ",");
			ЧастиАдреса.Удалить(0);
			НаселенныйПунктДетально.value = СокрЛП(СтрСоединить(ЧастиАдреса, ","));
			ПредставлениеАдреса           = НаселенныйПунктДетально.value;
		КонецЕсли;
		
		Страна                          = ОсновнаяСтрана;
		
	ИначеЕсли МеждународныйФорматАдреса Тогда
		
		Элементы.ПроверитьЗаполнениеАдреса.Видимость             = Ложь;
		Элементы.АдресныйКлассификаторУстарел.Видимость          = Ложь;
		Элементы.МуниципальноеДеление.Видимость                  = Ложь;
		Элементы.АдминистративноТерриториальноеДеление.Видимость = Ложь;
		Элементы.ЗаполнитьПоПочтовомуИндексу.Видимость           = Ложь;
		Элементы.ЗагрузитьКлассификатор.Видимость                = Ложь;
		Элементы.ГруппаИнформация.Видимость                      = Ложь;
		Элементы.НужнаПомощь.Видимость                           = Ложь;
		Элементы.СтраницаТипАдреса.ТекущаяСтраница               = Элементы.СтраницаДругойАдрес;
		
	КонецЕсли;
	НаселенныйПунктДетально.Country = НаименованиеСтраны(Страна, МеждународныйФорматАдреса);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ГруппаИнформационныеСообщения.Видимость    = Ложь;
		Элементы.НаселенныйПункт.МногострочныйРежим         = Истина;
		Элементы.ФормаКомандаОК.Отображение                 = ОтображениеКнопки.Картинка;
		Элементы.ТипДома.ОтображениеКнопкиВыбора            = ОтображениеКнопкиВыбора.Авто;
		Элементы.ТипСтроения.ОтображениеКнопкиВыбора        = ОтображениеКнопкиВыбора.Авто;
		элементы.ФормаОтмена.Видимость = Ложь;
	КонецЕсли;
	
	ОпределитьОтображениеЭлементовНаФорме(Параметры.ТолькоПросмотр);
	
	Если Не ЕстьПравоЗагружатьКлассификатор Тогда
		Элементы.ИнформацияОЗагрузкеАдресныеСведений.Заголовок = НСтр("ru = 'Для автоподбора и проверки адресов обратитесь к администратору для загрузки адресных сведений.';
																		|en = 'Address autosuggest requires address database. To import the database, contact your administrator.'");
		Элементы.ЗагрузитьКлассификатор.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьКлючИспользованияФормы();
	СформироватьМенюДобавленияСтроенийИПомещений();
	
	СформироватьТекстНужнаПомощь();

	
КонецПроцедуры

&НаКлиенте
&Вместо("ОчиститьАдресКлиент")
Процедура Рин1_ОчиститьАдресКлиент()
	
	РаботаСАдресамиКлиент.ОчиститьАдрес(НаселенныйПунктДетально);
	//bercut030720 Задача № 1521
	НаселенныйПунктДетально.addressType = РаботаСАдресамиКлиентСервер.АдминистративноТерриториальныйАдрес();
	//НаселенныйПунктДетально.addressType = РаботаСАдресамиКлиентСервер.МуниципальныйАдрес();
	//
	
	ОтобразитьДополнительныеЗдания();
	
КонецПроцедуры

&НаСервере
&Вместо("УстановитьЗначениеРеквизитовПоКонтактнойИнформации")
Процедура Рин1_УстановитьЗначениеРеквизитовПоКонтактнойИнформации(ДанныеАдреса)
	
	// Общие реквизиты
	ПредставлениеАдреса = ДанныеАдреса.Value;
	Если ДанныеАдреса.Свойство("Comment") Тогда
		Комментарий         = ДанныеАдреса.Comment;
	КонецЕсли;
	
	СсылкаНаОсновнуюСтрану = РаботаСАдресамиКлиентСервер.ОсновнаяСтрана();
	ДанныеСтраны = Неопределено;
	Если ДанныеАдреса.Свойство("Country") И ЗначениеЗаполнено(ДанныеАдреса.Country) Тогда
		ДанныеСтраны = Справочники.СтраныМира.ДанныеСтраныМира(, СокрЛП(ДанныеАдреса.Country));
	КонецЕсли;
	
	Если ДанныеСтраны = Неопределено Тогда
		// Не нашли ни в справочнике, ни в классификаторе.
		Страна    = СсылкаНаОсновнуюСтрану;
		КодСтраны = СсылкаНаОсновнуюСтрану.Код;
	Иначе
		Страна    = ДанныеСтраны.Ссылка;
		КодСтраны = ДанныеСтраны.Код;
	КонецЕсли;
	
	СведенияОСтране = СведенияОСтране(Страна);
	//++Шерстюк Ю.Ю. изменения без автора
	//Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоАдресВСвободнойФорме(ДанныеАдреса.AddressType) Тогда
	//	РазрешитьВводАдресаВСвободнойФорме = Истина;
	//КонецЕсли;
	//--Шерстюк Ю.Ю.	
	УстановитьЗначенияНациональныхРеквизитовКонтактнойИнформации(ДанныеАдреса);

КонецПроцедуры

&НаКлиенте
&Вместо("ПереключитьАдресВСвободнойФорму")
Процедура Рин1_ПереключитьАдресВСвободнойФорму()
	
	Элементы.ПроверитьЗаполнениеАдреса.Доступность = Ложь;
	//++Шерстюк Ю.Ю. изменения без автора
	//Если Элементы.АдресПредставлениеКомментарий.ТекущаяСтраница = Элементы.НациональныйАдрес Тогда
	//	РазрешитьВводАдресаВСвободнойФорме = Истина;
	//	ПоказатьАдресВСвободнойФорме();
	//	Возврат;
	//КонецЕсли;
	//--Шерстюк Ю.Ю.	
	РазрешитьВводАдресаВСвободнойФорме = Ложь;
	Элементы.АдресПредставлениеКомментарий.ТекущаяСтраница = Элементы.НациональныйАдрес;
	
	Если Не УправлениеКонтактнойИнформациейКлиентСервер.ЭтоАдресВСвободнойФорме(НаселенныйПунктДетально.AddressType) Тогда
		ОтобразитьВыданныйТипАдреса(НаселенныйПунктДетально.AddressType);
		Возврат;
	КонецЕсли;
		
	Если РаботаСАдресамиКлиентСервер.ЭтоОсновнаяСтрана(Страна) Тогда
		// Попытка восстановить адрес по полям из представления.
		НаселенныйПунктДетально = КонтактнаяИнформацияПоПредставлению(ПредставлениеАдреса, Комментарий, Истина);
		ОтобразитьВыданныйТипАдреса(НаселенныйПунктДетально.AddressType);
		Возврат;
	КонецЕсли;
		
	ЧастиАдреса = СтрРазделить(ПредставлениеАдреса, ",");
	Если СтрСравнить(Страна, ЧастиАдреса[0]) = 0 Тогда
		ЧастиАдреса.Удалить(0);
	КонецЕсли;
	
	Если ЧастиАдреса.Количество() > 1 Тогда
		ЧастьУлица = СокрЛП(ЧастиАдреса[ЧастиАдреса.Количество() - 1]);
		ЧастиАдреса.Удалить(ЧастиАдреса.Количество() - 1);
	Иначе
		ЧастьУлица = "";
	КонецЕсли;
	
	ЧастьГород = СокрЛП(?(ЧастиАдреса.Количество() > 0, СтрСоединить(ЧастиАдреса, ","), ""));
	
	Если СведенияОСтране.УчастникЕАЭС Тогда
		НаселенныйПунктДетально.AddressType = УправлениеКонтактнойИнформациейКлиентСервер.АдресЕАЭС();
		НаселенныйПунктДетально.Area = ЧастьГород;
	Иначе
		НаселенныйПунктДетально.AddressType = УправлениеКонтактнойИнформациейКлиентСервер.ИностранныйАдрес();
		НаселенныйПунктДетально.City = ЧастьГород;
	КонецЕсли;
	НаселенныйПунктДетально.Street = ЧастьУлица;
	
	ОтобразитьВыданныйТипАдреса(НаселенныйПунктДетально.AddressType);

КонецПроцедуры

&НаКлиенте
&Вместо("ПодтвердитьИЗакрыть")
Процедура Рин1_ПодтвердитьИЗакрыть(Результат, ДополнительныеПараметры)
	
	Если Модифицированность Тогда // При немодифицированности работает как "отмена".
		
		//bercut030720 Задача № 1521
		СписокОшибок = СписокОшибокЗаполнения(НаселенныйПунктДетально, ВидКонтактнойИнформации, Истина, Ложь);
		Если не СписокОшибок.Количество() = 0 Тогда
			СообщитьОбОшибкахЗаполнения(СписокОшибок, Истина, Ложь);
			//Возврат; 130720 Черевач просил отключить - проблема в том что фиас не содержал в себе улицы
		КонецЕсли;
		//
		
		Контекст = Новый Структура("ВидКонтактнойИнформации, НаселенныйПунктДетально, ОсновнаяСтрана, Страна");
		ЗаполнитьЗначенияСвойств(Контекст, ЭтотОбъект);
		Результат = РезультатВыбора(Контекст, ВозвращатьСписокЗначений);
		
		// Флаги вида были прочитаны заново.
		ВидКонтактнойИнформации = Контекст.ВидКонтактнойИнформации;
		
		Если (ВидКонтактнойИнформации.ПроверятьКорректность	И Не РазрешитьВводАдресаВСвободнойФорме
			Или ВидКонтактнойИнформации.МеждународныйФорматАдреса)
			И Результат.ОшибкиЗаполнения.Количество() > 0 Тогда
			
			СообщитьОбОшибкахЗаполнения(Результат.ОшибкиЗаполнения, Ложь);
			Возврат;
			
		КонецЕсли;
		
		Результат = Результат.ДанныеВыбора;
		Если ВидКонтактнойИнформации.ХранитьИсториюИзменений Тогда
			ОбработатьКонтактнуюИнформациюСИсторией(Результат);
		КонецЕсли;
		
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Результат.Вставить("КонтактнаяИнформацияОписаниеДополнительныхРеквизитов", КонтактнаяИнформацияОписаниеДополнительныхРеквизитов);
		КонецЕсли;
		
		СброситьМодифицированностьПриВыборе();
#Если ВебКлиент Тогда
		ФлагЗакрытия = ЗакрыватьПриВыборе;
		ЗакрыватьПриВыборе = Ложь;
		ОповеститьОВыборе(Результат);
		ЗакрыватьПриВыборе = ФлагЗакрытия;
#Иначе
		ОповеститьОВыборе(Результат);
#КонецЕсли
		СохранитьСостояниеФормы();
		
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Если (МодальныйРежим Или ЗакрыватьПриВыборе) И Открыта() Тогда
		СброситьМодифицированностьПриВыборе();
		СохранитьСостояниеФормы();
		Закрыть(Результат);
	КонецЕсли;

КонецПроцедуры

// + [Rineco], [Киселев А.Н.] [08.10.2021] 
// Задача: [№ 19725], [#ЗаполнениеАдреса]
&НаСервереБезКонтекста
&После("НаселенныйПунктУстановитьПоляАдреса")
Процедура Рин1_НаселенныйПунктУстановитьПоляАдреса(НаселенныйПунктДетально, Знач ВыбранноеЗначение, Знач ВключатьУлица)
	НаселенныйПунктДетально.AddressType = "Административно-территориальный";
КонецПроцедуры
