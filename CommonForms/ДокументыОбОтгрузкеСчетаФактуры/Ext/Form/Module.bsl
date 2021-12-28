﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетФактура                      = Параметры.СчетФактура;
	Контрагент                       = Параметры.Контрагент;
	ДоговорКонтрагента               = Параметры.ДоговорКонтрагента;
	ВидСчетаФактуры                  = Параметры.ВидСчетаФактуры;
	ВключитьВозможностьРедактировать = Параметры.ВключитьВозможностьРедактировать;
	АдресТаблицДокумента             = Параметры.АдресТаблицДокумента;
	ТаблицыДокумента                 = ПолучитьИзВременногоХранилища(АдресТаблицДокумента);
	
	ДокументыОбОтгрузке.Загрузить(ТаблицыДокумента.ТаблицаДокументовОбОтгрузке);
	ДокументыОснования.ЗагрузитьЗначения(ТаблицыДокумента.ТаблицаДокументовОснований);
	
	ДоступноРедактирование = ПравоДоступа("Изменение", Параметры.СчетФактура.Метаданные());
	ЭтотОбъект.ТолькоПросмотр = НЕ ДоступноРедактирование;
	Элементы.ВключитьВозможностьРедактировать.Доступность = ДоступноРедактирование;
	Элементы.ФормаЗаписатьИЗакрыть.Доступность            = ДоступноРедактирование;
	Элементы.ДокументыОбОтгрузке.Доступность              = ДоступноРедактирование И ВключитьВозможностьРедактировать;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПеренестиВДокумент Тогда
		СтруктураВозврата = ПриЗакрытииНаСервере();
		ОповеститьОВыборе(СтруктураВозврата);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И (Модифицированность ИЛИ ПеренестиВДокумент) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ ПеренестиВДокумент Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПеренестиВДокументЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
	Если ПеренестиВДокумент И НЕ Отказ Тогда
		Отказ = ЕстьОшибкиЗаполнения();
	КонецЕсли;
	
	Если Отказ Тогда
		ПеренестиВДокумент = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактироватьПриИзменении(Элемент)
	
	Элементы.ДокументыОбОтгрузке.Доступность = ВключитьВозможностьРедактировать;
	Если ВключитьВозможностьРедактировать Тогда
		ЗаполнитьОтгрузочныеДокументы();
	Иначе
		ДокументыОбОтгрузке.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ПеренестиВДокумент = Ложь;
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОтгрузочныеДокументы()
	
	// + [Rineco], [Киселев А.Н.] [12.11.2021] 
	// Задача: [№ 21791], [# Подстраиваем под ERP]
	СчетаФактуры = Документы.СчетФактураВыданный.ПолучитьСчетаФактурыНаПечать(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СчетФактура));
	СФ = СчетаФактуры.СчетаФактурыНаПечать[0];
		
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("НомерДокумента",ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СчетФактура.Номер,Истина));
	НайденныеСтроки = СчетФактура.ДокументыОбОтгрузке.НайтиСтроки(СтруктураПоиска);
	
	Если НайденныеСтроки <> Неопределено И Не ЗначениеЗаполнено(НайденныеСтроки) Тогда
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("ДополнитьКомплектВнешнимиПечатнымиФормами",Ложь);
		ПараметрыПечати.Вставить("ПечатьВВалюте",Ложь);
		ДанныеПечати = Документы.СчетФактураВыданный.ПолучитьДанныеДляПечатнойФормыСчетФактура(ПараметрыПечати,ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СФ));
		ТаблицаШапки = ДанныеПечати.РезультатПоШапке.Выгрузить();
		Строка5аСФ = ТаблицаШапки[0].ПредставлениеСтроки5а;
		ДокументОтгрузки  = ДокументыОбОтгрузке.Добавить();
		ДокументОтгрузки.НаименованиеДокумента = "Реализация (акт, накладная, УПД)";
		
		Если ПРАВ(Лев(Строка5аСФ,8),1) = "-" Тогда
			
			Если ДанныеПечати.РезультатПоТабличнойЧасти.Выгрузить().Количество() - 1 > 100 Тогда
				ДокументОтгрузки.НомераСтрок = ПРАВ(Лев(Строка5аСФ,11),5);
			Иначе 
				ДокументОтгрузки.НомераСтрок = ПРАВ(Лев(Строка5аСФ,10),4);
			КонецЕсли;
			
			
		Иначе 
			ДокументОтгрузки.НомераСтрок = "1";
		КонецЕсли;
		
		
		ДокументОтгрузки.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СчетФактура.Номер,Истина);
		ДокументОтгрузки.ДатаДокумента = СчетФактура.Дата;
		
	КонецЕсли;
	// - [Rineco], [Киселев А.Н.] [12.11.2021]

	
	Если ДокументыОснования.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеСчетаФактуры = Новый Структура();
	ДанныеСчетаФактуры.Вставить("Контрагент",                       Контрагент);
	ДанныеСчетаФактуры.Вставить("ВидСчетаФактуры",                  ВидСчетаФактуры);
	ДанныеСчетаФактуры.Вставить("ДоговорКонтрагента",               ДоговорКонтрагента);
	ДанныеСчетаФактуры.Вставить("ИспользуетсяПостановлениеНДС1137", Истина);
	ДанныеСчетаФактуры.Вставить("СчетФактура",                      СчетФактура);
	ДанныеСчетаФактуры.Вставить("НомерСтроки",                      Неопределено);
	
	ТаблицаДокумента = Неопределено;
	Для Каждого Основание Из ДокументыОснования Цикл
		ПараметрыДокумента = УчетНДС.ПодготовитьДанныеДляПечатиСчетовФактур(Основание.Значение, ДанныеСчетаФактуры);
		Если ЗначениеЗаполнено(ПараметрыДокумента.ТаблицаДокумента) Тогда
			Если ТаблицаДокумента = Неопределено Тогда
				ТаблицаДокумента = ПараметрыДокумента.ТаблицаДокумента;
			Иначе
				ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ПараметрыДокумента.ТаблицаДокумента, ТаблицаДокумента);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ТаблицаДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущийДокумент = Неопределено;
	ПерваяСтрокаПоДокументуОтгрузки = 1;
	ПоследняяСтрокаПоДокументуОтгрузки = 1;
	ШаблонПодстрокиДокументаОбОтгрузке = "№ п/п %1 №%2 от %3";
	Для ИндексСтроки = 0 По ТаблицаДокумента.Количество() - 1 Цикл
		ЭтоПоследняяСтрока = (ИндексСтроки = ТаблицаДокумента.Количество() - 1);
		ТекущийНомерСтроки = ИндексСтроки + 1;
		ПоследняяСтрокаПоДокументуОтгрузки = ТекущийНомерСтроки;
		
		// Для 1-й строки установим предыдущий документ.
		Если Не ЗначениеЗаполнено(ПредыдущийДокумент) Тогда
			// Запоминаем первый документ отгрузки.
			ПредыдущийДокумент = ТаблицаДокумента[ИндексСтроки].Ссылка;
		КонецЕсли;
		
		Если ТаблицаДокумента[ИндексСтроки].Ссылка <> ПредыдущийДокумент Тогда
			// Выводим предыдущий документ.
			ПоследняяСтрокаПоДокументуОтгрузки = ТекущийНомерСтроки - 1;
			
			Если (ПоследняяСтрокаПоДокументуОтгрузки - ПерваяСтрокаПоДокументуОтгрузки) > 0 Тогда
				ДиапазонСтрок = "" + ПерваяСтрокаПоДокументуОтгрузки + "-" + ПоследняяСтрокаПоДокументуОтгрузки;
			Иначе
				ДиапазонСтрок = ПерваяСтрокаПоДокументуОтгрузки;
			КонецЕсли;
			Если ТипЗнч(ТаблицаДокумента[ИндексСтроки-1].Ссылка) = Тип("ДокументСсылка.ОказаниеУслуг") Тогда
				ПостфиксНомераДокумента = "/" + Строка(ТаблицаДокумента[ИндексСтроки-1].НомерСтроки);
			Иначе
				ПостфиксНомераДокумента = "";
			КонецЕсли;
			ДокументОтгрузки  = ДокументыОбОтгрузке.Добавить();
			ДокументОтгрузки.НаименованиеДокумента = "Реализация (акт, накладная, УПД)";
			ДокументОтгрузки.НомераСтрок = ДиапазонСтрок;
			ДокументОтгрузки.НомерДокумента = Строка(ТаблицаДокумента[ИндексСтроки-1].НомерОтгрузочногоДокумента) + ПостфиксНомераДокумента;
			ДокументОтгрузки.ДатаДокумента = ТаблицаДокумента[ИндексСтроки-1].ДатаОтгрузочногоДокумента;
			
			ПерваяСтрокаПоДокументуОтгрузки = ТекущийНомерСтроки;
			ПоследняяСтрокаПоДокументуОтгрузки    = ТекущийНомерСтроки;
			ПредыдущийДокумент = ТаблицаДокумента[ИндексСтроки].Ссылка;
		КонецЕсли;
		
		Если ЭтоПоследняяСтрока Тогда
			// Выводим последний документ.
			Если (ПоследняяСтрокаПоДокументуОтгрузки - ПерваяСтрокаПоДокументуОтгрузки) > 0 Тогда
				ДиапазонСтрок = "" + ПерваяСтрокаПоДокументуОтгрузки + "-" + ПоследняяСтрокаПоДокументуОтгрузки;
			Иначе
				ДиапазонСтрок = ПерваяСтрокаПоДокументуОтгрузки;
			КонецЕсли;
			Если ТипЗнч(ТаблицаДокумента[ИндексСтроки].Ссылка) = Тип("ДокументСсылка.ОказаниеУслуг") Тогда
				ПостфиксНомераДокумента = "/" + Строка(ТаблицаДокумента[ИндексСтроки].НомерСтроки);
			Иначе
				ПостфиксНомераДокумента = "";
			КонецЕсли;
			
			ДокументОтгрузки  = ДокументыОбОтгрузке.Добавить();
			ДокументОтгрузки.НомераСтрок = ДиапазонСтрок;
			ДокументОтгрузки.НаименованиеДокумента = "Реализация (акт, накладная, УПД)";
			ДокументОтгрузки.НомерДокумента = Строка(ТаблицаДокумента[ИндексСтроки].НомерОтгрузочногоДокумента) + ПостфиксНомераДокумента;
			ДокументОтгрузки.ДатаДокумента = ТаблицаДокумента[ИндексСтроки].ДатаОтгрузочногоДокумента;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПриЗакрытииНаСервере()
	
	СтруктураВозврата = Новый Структура();
	
	Если ПеренестиВДокумент Тогда
		СтруктураВозврата.Вставить("ОтредактированыДокументыОтгрузки", ВключитьВозможностьРедактировать);
		ТаблицаДокументовОбОтгрузке = ДокументыОбОтгрузке.Выгрузить();
		АдресТаблицыОтгрузочныхДокументов = ПоместитьВоВременноеХранилище(ТаблицаДокументовОбОтгрузке, УникальныйИдентификатор);
		СтруктураВозврата.Вставить("АдресТаблицыОтгрузочныхДокументов", АдресТаблицыОтгрузочныхДокументов);
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Функция ЕстьОшибкиЗаполнения()
	
	Отказ = Ложь;
	Для Индекс = 0 По ДокументыОбОтгрузке.Количество() - 1 Цикл
		
		СтрокаТаблицы = ДокументыОбОтгрузке[Индекс];
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.НомераСтрок) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 не указаны номера строк.'"),
				Индекс + 1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"ДокументыОбОтгрузке["+Индекс+"].НомераСтрок",
				,
				Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.НомерДокумента) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 не указан номер документа.'"),
				Индекс + 1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"ДокументыОбОтгрузке["+Индекс+"].НомерДокумента",
				,
				Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаДокумента) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 не указана дата документа.'"),
				Индекс + 1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"ДокументыОбОтгрузке["+Индекс+"].ДатаДокумента",
				,
				Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.НаименованиеДокумента) Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 не указано наименование документа.'"),
				Индекс + 1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"ДокументыОбОтгрузке["+Индекс+"].НаименованиеДокумента",
				,
				Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Отказ;
	
КонецФункции

&НаКлиенте
Процедура ВопросПеренестиВДокументЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти