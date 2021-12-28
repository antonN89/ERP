﻿
Функция ГИГ_ПечатьКоммерческоеПредложениеMicrosoftWord(ОписаниеКоманды)
	
	ОчиститьСообщения();
	
	Состояние(НСтр("ru = 'Выполняется формирование печатных форм'"));
	
	ИмяМакета = "ПФ_DOC_КоммерческоеПредложение";
	ТипМакета = "doc";
	
	МакетИДанныеОбъекта = УправлениеПечатьюВызовСервера.МакетыИДанныеОбъектовДляПечати("Документ.КоммерческоеПредложениеКлиенту",
		ИмяМакета,
		ОписаниеКоманды.ОбъектыПечати);
		
	ДвоичныеДанныеМакетов = МакетИДанныеОбъекта.Макеты.ДвоичныеДанныеМакетов;
	
	Секции = МакетИДанныеОбъекта.Макеты.ОписаниеСекций;
	
	Для Каждого ДокументСсылка Из ОписаниеКоманды.ОбъектыПечати Цикл
		
		ДанныеОбъекта = МакетИДанныеОбъекта.Данные[ДокументСсылка][ИмяМакета];
		
		Попытка
			
			ПечатнаяФорма = УправлениеПечатьюКлиент.ИнициализироватьПечатнуюФорму(ТипМакета);
			Макет = УправлениеПечатьюКлиент.ИнициализироватьМакетОфисногоДокумента(
				ДвоичныеДанныеМакетов[ИмяМакета], ТипМакета);
			
			// Вывод колонтитулов документа.
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета]["ВерхнийКолонтитул"]);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета]["НижнийКолонтитул"]);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].Заголовок);
			УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область, Ложь);
			УправлениеПечатьюКлиент.ЗаполнитьПараметры(ПечатнаяФорма, ДанныеОбъекта);
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.КонтактноеЛицо) Тогда
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].КонтактноеЛицо);
				УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область, Ложь);
				УправлениеПечатьюКлиент.ЗаполнитьПараметры(ПечатнаяФорма, ДанныеОбъекта);
			КонецЕсли;
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].Предложение);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ДанныеОбъекта.ЕстьСкидки Тогда
				ПостфиксСтрок = "";
			Иначе
				ПостфиксСтрок = "БезСкидки";
			КонецЕсли;
			
			ОбластьСтрокаТаблицыТоварыСтандарт    = Секции[ИмяМакета]["СтрокаТаблицаТовары" + ПостфиксСтрок];
			ОбластьШапкаТаблицыТовары             = Секции[ИмяМакета]["ШапкаТаблицаТовары"  + ПостфиксСтрок];
			
			//Если ДанныеОбъекта.ИспользоватьНаборы Тогда
			//	ОбластьСтрокаТаблицыТоварыНабор              = Секции[ИмяМакета]["СтрокаТаблицаТовары"  + ПостфиксСтрок + "Набор"];
			//	ОбластьСтрокаТаблицыТоварыКомплектующие      = Секции[ИмяМакета]["СтрокаТаблицаТовары"  + ПостфиксСтрок + "Комплектующие"];
			//	ОбластьСтрокаТаблицыТоварыКомплектующиеКонец = Секции[ИмяМакета]["СтрокаТаблицаТовары"  + ПостфиксСтрок + "КомплектующиеКонец"];
			//КонецЕсли;
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,ОбластьШапкаТаблицыТовары);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Индекс = 0;
			ВсегоСтрок = ДанныеОбъекта.Товары.Количество();
			Для Каждого СтрокаТЧ Из ДанныеОбъекта.Товары Цикл
				
				Индекс = Индекс + 1;
				
				//Если НаборыКлиентСервер.ИспользоватьОбластьНабор(СтрокаТЧ, ДанныеОбъекта.ИспользоватьНаборы) Тогда
				//	ОбластьСтрокаТаблицыТовары = ОбластьСтрокаТаблицыТоварыНабор;
				//ИначеЕсли НаборыКлиентСервер.ИспользоватьОбластьКомплектующие(СтрокаТЧ, ДанныеОбъекта.ИспользоватьНаборы) И Индекс < ВсегоСтрок Тогда
				//	ОбластьСтрокаТаблицыТовары = ОбластьСтрокаТаблицыТоварыКомплектующие;
				//ИначеЕсли НаборыКлиентСервер.ИспользоватьОбластьКомплектующие(СтрокаТЧ, ДанныеОбъекта.ИспользоватьНаборы) Тогда
				//	ОбластьСтрокаТаблицыТовары = ОбластьСтрокаТаблицыТоварыКомплектующиеКонец;
				//Иначе
					ОбластьСтрокаТаблицыТовары = ОбластьСтрокаТаблицыТоварыСтандарт;
				//КонецЕсли;
				
				Масс = Новый Массив;
				Масс.Добавить(СтрокаТЧ);
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, ОбластьСтрокаТаблицыТовары);
				УправлениеПечатьюКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, Область, Масс, Ложь);
				
			КонецЦикла;
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ИтоговаяСтрока);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.СрокДействия) Тогда
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].СрокДействия);
				УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область, Ложь);
				УправлениеПечатьюКлиент.ЗаполнитьПараметры(ПечатнаяФорма, ДанныеОбъекта);
			КонецЕсли;
			
			//Если ЗначениеЗаполнено(ДанныеОбъекта.ГрафикОплаты)
			//	ИЛИ ЗначениеЗаполнено(ДанныеОбъекта.ФормаОплаты)
			//	ИЛИ ЗначениеЗаполнено(ДанныеОбъекта.Склад)
			//	ИЛИ ЗначениеЗаполнено(ДанныеОбъекта.ДополнительнаяИнформация) Тогда
			//	
			//	Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ЗаголовокДопИнформации);
			//	УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			//КонецЕсли;
			//
			//Если ЗначениеЗаполнено(ДанныеОбъекта.ГрафикОплаты) Тогда
			//	
			//	Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ГрафикОплаты);
			//	УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			//	
			//КонецЕсли;
			//
			//Если ЗначениеЗаполнено(ДанныеОбъекта.ФормаОплаты) Тогда
			//	
			//	Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ФормаОплаты);
			//	УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			//	
			//КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.Склад) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].Склад);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			//Если ЗначениеЗаполнено(ДанныеОбъекта.ДополнительнаяИнформация) Тогда
			//	
			//	Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ДополнительнаяИнформация);
			//	УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			//	
			//КонецЕсли;
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].Подвал);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.ТелефонОрганизации) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ТелефонОрганизации);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.АдресЭлектроннойПочтыМенеджера) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].АдресЭлектроннойПочтыМенеджера);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			УправлениеПечатьюКлиент.ПоказатьДокумент(ПечатнаяФорма);
			
			
			//// вывод приложений по Вариантам расчета
			//
			//Word = ПечатнаяФорма.COMСоединение;
			//Select = Word.Selection;
			//Docum = Word.Application.Documents(1);
			//ОбластьПриложение = Секции[ИмяМакета].Приложение;
			//
			////****************************
			//МассивВыведенныхФайлов = Новый Массив;
			//Если ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура.Количество() <> 0 Тогда
			//	НомерПриложения = ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура[0].Приложение;
			//	НомерПоследнегоПриложения = ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура[ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура.Количество()-1].Приложение;
			//	Пока НомерПриложения <= НомерПоследнегоПриложения Цикл
			//		//выведем номер приложения
			//		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].Приложение);
			//		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, Новый Структура("НомерПриложения", НомерПриложения), Ложь);
			//		МассивСтрокКВыводу = Новый Массив;
			//		ВариантПараметров = ПредопределенноеЗначение("Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ПустаяСсылка");
			//		Для Каждого ТекСтрока Из ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура Цикл
			//			Если НомерПриложения <> ТекСтрока.Приложение Тогда
			//				Продолжить;
			//			КонецЕсли;
			//			МассивСтрокКВыводу.Добавить(ТекСтрока);
			//			ВариантПараметров = ТекСтрока.ВариантПараметров;
			//		КонецЦикла;
			//		Если МассивСтрокКВыводу.Количество() > 0 Тогда
			//			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ШапкаТаблицаВыделеннаяНоменклатура);
			//			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			//			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].СтрокаТаблицаВыделеннаяНоменклатура);
			//			УправлениеПечатьюКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма,Область, МассивСтрокКВыводу, Ложь);
			//		КонецЕсли;
			//		
			//		Для Каждого СтрокаТЧ Из ДанныеОбъекта.ВариантыРасчета Цикл
			//			Если СтрокаТЧ.ВариантПараметров <> ВариантПараметров Тогда
			//				Продолжить;
			//			КонецЕсли;
			//			СсылкаНаФайл = СтрокаТЧ.СсылкаНаФайл;
			//			Если СсылкаНаФайл <> Null Тогда
			//				ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(СсылкаНаФайл, Неопределено, Новый УникальныйИдентификатор());
			//				ИмяФайла = ПолучитьИмяВременногоФайла(".doc");
			//				ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
			//				ДвоичныеДанные.Записать(ИмяФайла);
			//				
			//				Docum.Sections.Add(Docum.Characters.Last,2).Range.Select();
			//				Select.InsertFile(ИмяФайла);
			//				МассивВыведенныхФайлов.Добавить(СтрокаТЧ.ВариантПараметров);
			//			КонецЕсли;
			//		КонецЦикла;
			//		НомерПриложения = НомерПриложения + 1;
			//	КонецЦикла;
			//КонецЕсли;
			//
			////выведем оставшиеся приложения
			//Для Каждого СтрокаТЧ Из ДанныеОбъекта.ВариантыРасчета Цикл
			//	Если МассивВыведенныхФайлов.Найти(СтрокаТЧ.ВариантПараметров) <> Неопределено Тогда
			//		Продолжить;
			//	КонецЕсли;
			//	СсылкаНаФайл = СтрокаТЧ.СсылкаНаФайл;
			//	Если СсылкаНаФайл <> Null Тогда
			//		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(СсылкаНаФайл, Неопределено, Новый УникальныйИдентификатор());
			//		ИмяФайла = ПолучитьИмяВременногоФайла(".doc");
			//		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
			//		ДвоичныеДанные.Записать(ИмяФайла);
			//		
			//		Docum.Sections.Add(Docum.Characters.Last,2).Range.Select();
			//		Select.InsertFile(ИмяФайла);					
			//	КонецЕсли;
			//КонецЦикла;
			
			//// вывод приложений по Вариантам расчета
			//Word = ПечатнаяФорма.COMСоединение;
			//Select = Word.Selection;
			//Docum = Word.Application.Documents(1);
			//ОбластьПриложение = Секции[ИмяМакета].Приложение;
			//Индекс = 0;
			//Для Каждого СтрокаТЧ Из ДанныеОбъекта.ВариантыРасчета Цикл
			//	
			//	Индекс = Индекс + 1;
			//	
			//	СтруктураЗаполнения = Новый Структура;
			//	СтруктураЗаполнения.Вставить("НомерПриложения", Строка(Индекс));
			//	
			//	СсылкаНаФайл = СтрокаТЧ.СсылкаНаФайл;
			//	Если СсылкаНаФайл <> Null Тогда
			//		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(СсылкаНаФайл, Неопределено, Новый УникальныйИдентификатор());
			//		ИмяФайла = ПолучитьИмяВременногоФайла(".doc");
			//		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
			//		ДвоичныеДанные.Записать(ИмяФайла);
			//		//ПечатнаяФорма.COMСоединение
			//		//Select = ПечатнаяФорма.Selection;
			//		Docum.Sections.Add(Docum.Characters.Last,2).Range.Select();
			//		Select.InsertFile(ИмяФайла);
			//	КонецЕсли;
			//	
			//КонецЦикла;
			
		Исключение
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма);
			УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
			
			Возврат Ложь;
			
		КонецПопытки;
		
		УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма, Ложь);
		УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
		
	КонецЦикла;
	
	Состояние(НСтр("ru = 'Формирование печатных форм завершено'"));
	
КонецФункции

Функция ГИГ_ПечатьКоммерческоеПредложениеOpenOfficeOrgWriter(ОписаниеКоманды)
	
	ОчиститьСообщения();
	
	Состояние(НСтр("ru = 'Выполняется формирование печатных форм'"));
	
	ИмяМакета = "ПФ_ODT_КоммерческоеПредложение";
	ТипМакета = "odt";
	
	МакетИДанныеОбъекта = УправлениеПечатьюВызовСервера.МакетыИДанныеОбъектовДляПечати("Документ.КоммерческоеПредложениеКлиенту",
		ИмяМакета,
		ОписаниеКоманды.ОбъектыПечати);
		
	ДвоичныеДанныеМакетов = МакетИДанныеОбъекта.Макеты.ДвоичныеДанныеМакетов;
	
	Секции = МакетИДанныеОбъекта.Макеты.ОписаниеСекций;
	
	Для Каждого ДокументСсылка Из ОписаниеКоманды.ОбъектыПечати Цикл
		
		ДанныеОбъекта = МакетИДанныеОбъекта.Данные[ДокументСсылка][ИмяМакета];
		
		Попытка
			
			ПечатнаяФорма = УправлениеПечатьюКлиент.ИнициализироватьПечатнуюФорму(ТипМакета);
			Макет = УправлениеПечатьюКлиент.ИнициализироватьМакетОфисногоДокумента(
				ДвоичныеДанныеМакетов[ИмяМакета], ТипМакета);
				
			// Вывод колонтитулов документа.
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета]["ВерхнийКолонтитул"]);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета]["НижнийКолонтитул"]);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].Заголовок);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.КонтактноеЛицо) Тогда
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].КонтактноеЛицо);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			КонецЕсли;
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].Предложение);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ДанныеОбъекта.ЕстьСкидки Тогда
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ШапкаТаблицаТовары);
			Иначе
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ШапкаТаблицаТоварыБезСкидки);
			КонецЕсли;
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ДанныеОбъекта.ЕстьСкидки Тогда
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].СтрокаТаблицаТовары);
			Иначе
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].СтрокаТаблицаТоварыБезСкидки);
			КонецЕсли;
			УправлениеПечатьюКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма,Область, ДанныеОбъекта.Товары, Ложь);
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ИтоговаяСтрока);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.СрокДействия) Тогда
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].СрокДействия);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.ГрафикОплаты)
				Или ЗначениеЗаполнено(ДанныеОбъекта.ФормаОплаты)
				Или ЗначениеЗаполнено(ДанныеОбъекта.Склад)
				Или ЗначениеЗаполнено(ДанныеОбъекта.ДополнительнаяИнформация) Тогда
			
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ЗаголовокДопИнформации);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.ГрафикОплаты) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ГрафикОплаты);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.ФормаОплаты) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ФормаОплаты);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.Склад) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].Склад);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.ДополнительнаяИнформация) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ДополнительнаяИнформация);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].Подвал);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.ТелефонОрганизации) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ТелефонОрганизации);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.АдресЭлектроннойПочтыМенеджера) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].АдресЭлектроннойПочтыМенеджера);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			УправлениеПечатьюКлиент.ПоказатьДокумент(ПечатнаяФорма);
			
			// вывод приложений по Вариантам расчета
			
			//****************************
			МассивВыведенныхФайлов = Новый Массив;
			Если ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура.Количество() <> 0 Тогда
				НомерПриложения = ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура[0].Приложение;
				НомерПоследнегоПриложения = ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура[ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура.Количество()-1].Приложение;
				Пока НомерПриложения <= НомерПоследнегоПриложения Цикл
					//выведем номер приложения
					Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].Приложение);
					УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, Новый Структура("НомерПриложения", НомерПриложения), Ложь);
					МассивСтрокКВыводу = Новый Массив;
					ВариантПараметров = ПредопределенноеЗначение("Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ПустаяСсылка");
					Для Каждого ТекСтрока Из ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура Цикл
						Если НомерПриложения <> ТекСтрока.Приложение Тогда
							Продолжить;
						КонецЕсли;
						МассивСтрокКВыводу.Добавить(ТекСтрока);
						ВариантПараметров = ТекСтрока.ВариантПараметров;
					КонецЦикла;
					Если МассивСтрокКВыводу.Количество() > 0 Тогда
						Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ШапкаТаблицаВыделеннаяНоменклатура);
						УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
						Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].СтрокаТаблицаВыделеннаяНоменклатура);
						УправлениеПечатьюКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма,Область, МассивСтрокКВыводу, Ложь);
					КонецЕсли;
					
					Для Каждого СтрокаТЧ Из ДанныеОбъекта.ВариантыРасчета Цикл
						Если СтрокаТЧ.ВариантПараметров <> ВариантПараметров Тогда
							Продолжить;
						КонецЕсли;
						СсылкаНаФайл = СтрокаТЧ.СсылкаНаФайл;
						Если СсылкаНаФайл <> Null Тогда
							ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(СсылкаНаФайл, Неопределено, Новый УникальныйИдентификатор());
							ИмяФайла = ПолучитьИмяВременногоФайла(".doc");
							ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
							ДвоичныеДанные.Записать(ИмяФайла);
							
							ПутьКФайлу = СтрЗаменить(СтрЗаменить(СокрЛП(ИмяФайла), "\", "/"), " ", "%20");
							Если ЗначениеЗаполнено(ИмяФайла) И Найти(ИмяФайла, "file:///") = 0 Тогда 
								ПутьКФайлу = "file:///" + ПутьКФайлу; 
							КонецЕсли;
							
							Если ЗначениеЗаполнено(ПутьКФайлу) Тогда
								//Параметры для встраивания на место найденного фрагмента содержимого документа
								ПараметрыUNO = ПолучитьComSafeArray();
								#Если НЕ ВебКлиент Тогда
									ПараметрыUNO.SetValue(0, СвойствоЗначение(ПечатнаяФорма.ServiceManager, "Name", ПутьКФайлу));
								#Иначе
									УстановитьСвойствоЗначение(ПараметрыUNO, 0, "Name", ПутьКФайлу);
								#КонецЕсли
								
								oViewCursor = ПечатнаяФорма.Document.getCurrentController().getViewCursor();
								dispatcher = ПечатнаяФорма.ServiceManager.CreateInstance("com.sun.star.frame.DispatchHelper");
								oFrame = ПечатнаяФорма.Document.getCurrentController().Frame;
							КонецЕсли; 
							
							//Иначе вставляем в конец файла
							УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
							dispatcher.executeDispatch(oFrame, ".uno:InsertDoc", "", 0, ПараметрыUNO);
							МассивВыведенныхФайлов.Добавить(СтрокаТЧ.ВариантПараметров);
						КонецЕсли;
					КонецЦикла;
					НомерПриложения = НомерПриложения + 1;
				КонецЦикла;
			КонецЕсли;
			
			//выведем оставшиеся приложения
			Для Каждого СтрокаТЧ Из ДанныеОбъекта.ВариантыРасчета Цикл
				Если МассивВыведенныхФайлов.Найти(СтрокаТЧ.ВариантПараметров) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				СсылкаНаФайл = СтрокаТЧ.СсылкаНаФайл;
				Если СсылкаНаФайл <> Null Тогда
					ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(СсылкаНаФайл, Неопределено, Новый УникальныйИдентификатор());
					ИмяФайла = ПолучитьИмяВременногоФайла(".doc");
					ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
					ДвоичныеДанные.Записать(ИмяФайла);
					
					ПутьКФайлу = СтрЗаменить(СтрЗаменить(СокрЛП(ИмяФайла), "\", "/"), " ", "%20");
					Если ЗначениеЗаполнено(ИмяФайла) И Найти(ИмяФайла, "file:///") = 0 Тогда 
						ПутьКФайлу = "file:///" + ПутьКФайлу; 
					КонецЕсли;
					
					Если ЗначениеЗаполнено(ПутьКФайлу) Тогда
						//Параметры для встраивания на место найденного фрагмента содержимого документа
						ПараметрыUNO = ПолучитьComSafeArray();
						#Если НЕ ВебКлиент Тогда
							ПараметрыUNO.SetValue(0, СвойствоЗначение(ПечатнаяФорма.ServiceManager, "Name", ПутьКФайлу));
						#Иначе
							УстановитьСвойствоЗначение(ПараметрыUNO, 0, "Name", ПутьКФайлу);
						#КонецЕсли
						
						oViewCursor = ПечатнаяФорма.Document.getCurrentController().getViewCursor();
						dispatcher = ПечатнаяФорма.ServiceManager.CreateInstance("com.sun.star.frame.DispatchHelper");
						oFrame = ПечатнаяФорма.Document.getCurrentController().Frame;
					КонецЕсли; 
					
					//Иначе вставляем в конец файла
					УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
					dispatcher.executeDispatch(oFrame, ".uno:InsertDoc", "", 0, ПараметрыUNO);
					
				КонецЕсли;
				
			КонецЦикла;
			
			
			
			
			
			
			
			
			//Если ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура.Количество() <> 0 Тогда
			//	НомерПриложения = ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура[0].Приложение;
			//	НомерПоследнегоПриложения = ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура[ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура.Количество()-1].Приложение;
			//	Пока НомерПриложения <= НомерПоследнегоПриложения Цикл
			//		//выведем номер приложения
			//		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].Приложение);
			//		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, Новый Структура("НомерПриложения", НомерПриложения), Ложь);
			//		МассивСтрокКВыводу = Новый Массив;
			//		ВариантПараметров = ПредопределенноеЗначение("Справочник.гиг_ВариантыПараметровНоменклатурыПроекта.ПустаяСсылка");
			//		Для Каждого ТекСтрока Из ДанныеОбъекта.ТаблицаВыделеннаяНоменклатура Цикл
			//			Если НомерПриложения <> ТекСтрока.Приложение Тогда
			//				Продолжить;
			//			КонецЕсли;
			//			МассивСтрокКВыводу.Добавить(ТекСтрока);
			//			ВариантПараметров = ТекСтрока.ВариантПараметров;
			//		КонецЦикла;
			//		Если МассивСтрокКВыводу.Количество() > 0 Тогда
			//			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ШапкаТаблицаВыделеннаяНоменклатура);
			//			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			//			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].СтрокаТаблицаВыделеннаяНоменклатура);
			//			УправлениеПечатьюКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма,Область, МассивСтрокКВыводу, Ложь);
			//		КонецЕсли;
					
					//Для Каждого СтрокаТЧ Из ДанныеОбъекта.ВариантыРасчета Цикл
					//	Если СтрокаТЧ.ВариантПараметров <> ВариантПараметров Тогда
					//		Продолжить;
					//	КонецЕсли;
					//	СсылкаНаФайл = СтрокаТЧ.СсылкаНаФайл;
					//	Если СсылкаНаФайл <> Null Тогда
					//		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(СсылкаНаФайл, Неопределено, Новый УникальныйИдентификатор());
					//		ИмяФайла = ПолучитьИмяВременногоФайла(".doc");
					//		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
					//		ДвоичныеДанные.Записать(ИмяФайла);
					//		
					//		ПутьКФайлу = СтрЗаменить(СтрЗаменить(СокрЛП(ИмяФайла), "\", "/"), " ", "%20");
					//		Если ЗначениеЗаполнено(ИмяФайла) И Найти(ИмяФайла, "file:///") = 0 Тогда 
					//			ПутьКФайлу = "file:///" + ПутьКФайлу; 
					//		КонецЕсли;
					//		
					//		Если ЗначениеЗаполнено(ПутьКФайлу) Тогда
					//			//Параметры для встраивания на место найденного фрагмента содержимого документа
					//			ПараметрыUNO = ПолучитьComSafeArray();
					//			#Если НЕ ВебКлиент Тогда
					//				ПараметрыUNO.SetValue(0, СвойствоЗначение(ПечатнаяФорма.ServiceManager, "Name", ПутьКФайлу));
					//			#Иначе
					//				УстановитьСвойствоЗначение(ПараметрыUNO, 0, "Name", ПутьКФайлу);
					//			#КонецЕсли
					//			
					//			oViewCursor = ПечатнаяФорма.Document.getCurrentController().getViewCursor();
					//			dispatcher = ПечатнаяФорма.ServiceManager.CreateInstance("com.sun.star.frame.DispatchHelper");
					//			oFrame = ПечатнаяФорма.Document.getCurrentController().Frame;
					//		КонецЕсли; 
					//		
					//		//Иначе вставляем в конец файла
					//		УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
					//		dispatcher.executeDispatch(oFrame, ".uno:InsertDoc", "", 0, ПараметрыUNO);
					//		
					//	КонецЕсли;
					//	
					//КонецЦикла;
			//		НомерПриложения = НомерПриложения + 1;
			//	КонецЦикла;
			//КонецЕсли;
			
			
			//*********************************************
			

			
			
			
			
			//Word = ПечатнаяФорма.COMСоединение;
			//Select = Word.Selection;
			//Docum = Word.Application.Documents(1);
			//ОбластьПриложение = Секции[ИмяМакета].ВариантРасчета;
			//Индекс = 0;
			//Для Каждого СтрокаТЧ Из ДанныеОбъекта.ВариантыРасчета Цикл
			//	
			//	Индекс = Индекс + 1;
			//	
			//	СтруктураЗаполнения = Новый Структура;
			//	СтруктураЗаполнения.Вставить("НомерПриложения", Строка(Индекс));
			//	
			//	СсылкаНаФайл = СтрокаТЧ.СсылкаНаФайл;
			//	Если СсылкаНаФайл <> Null Тогда
			//		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(СсылкаНаФайл, Неопределено, Новый УникальныйИдентификатор());
			//		ИмяФайла = ПолучитьИмяВременногоФайла(".doc");
			//		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
			//		ДвоичныеДанные.Записать(ИмяФайла);
			//		//ПечатнаяФорма.COMСоединение
			//		//Select = ПечатнаяФорма.Selection;
			//		Docum.Sections.Add(Docum.Characters.Last,2).Range.Select();
			//		Select.InsertFile(ИмяФайла);
			//	КонецЕсли;
			//	
			//КонецЦикла;
			
		Исключение
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма);
			УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
				
			Возврат Ложь;
			
		КонецПопытки;

		УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма, Ложь);
		УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
		
	КонецЦикла;
	
	Состояние(НСтр("ru = 'Формирование печатных форм завершено'"));
	
КонецФункции

Функция ПолучитьComSafeArray()
	
#Если ВебКлиент Тогда
	scr = Новый COMОбъект("MSScriptControl.ScriptControl");
	scr.language = "javascript";
	scr.eval("Массив=new Array()");
	Возврат scr.eval("Массив");
#Иначе
	Возврат Новый COMSafeArray("VT_DISPATCH", 1);
#КонецЕсли
	
КонецФункции

// Получает специальную структуру, через которую объектам UNO устанавливаются
// параметры.
//
Функция СвойствоЗначение(Знач ServiceManager, Знач Свойство, Знач Значение)
	
	PropertyValue = ServiceManager.Bridge_GetStruct("com.sun.star.beans.PropertyValue");
	PropertyValue.Name = Свойство;
	PropertyValue.Value = Значение;
	
	Возврат PropertyValue;
	
КонецФункции

// Выводит печатную форму коммерческого предложения в open office.
//
// Параметры:
//  ОписаниеКоманды	 - Структура - структура с описанием команды.
// 
// Возвращаемое значение:
//  Неопределено - ничего не возвращается.
//
Функция ПечатьКоммерческоеПредложениеOpenOfficeOrgWriter(ОписаниеКоманды) Экспорт
	
	ГИГ_ПечатьКоммерческоеПредложениеOpenOfficeOrgWriter(ОписаниеКоманды);
	Возврат Ложь;
		
КонецФункции

// Выводит печатную форму коммерческого предложения в word.
//
// Параметры:
//  ОписаниеКоманды	 - Структура - структура с описанием команды.
// 
// Возвращаемое значение:
//  Неопределено - ничего не возвращается.
//
Функция ПечатьКоммерческоеПредложениеMicrosoftWord(ОписаниеКоманды) Экспорт
	
		Для Каждого ДокументСсылка Из ОписаниеКоманды.ОбъектыПечати Цикл
		Если гиг_РасчетИзделийВызовСервера.РасчетИзделийПоПроектуКоммерческогоПредложения(ДокументСсылка) Тогда
			//применим свою печать коммерческого предложения
			Возврат ГИГ_ПечатьКоммерческоеПредложениеMicrosoftWord(ОписаниеКоманды);
		КонецЕсли;
	КонецЦикла;
	//--Гольм А.А. (Гигабайт) 18.03.2019 14:02:08

	ОчиститьСообщения();
	
	Состояние(НСтр("ru = 'Выполняется формирование печатных форм';
					|en = 'Generating print forms'"));
	
	ИмяМакета = "ПФ_DOC_КоммерческоеПредложение";
	ТипМакета = "doc";
	
	МакетИДанныеОбъекта = УправлениеПечатьюВызовСервера.МакетыИДанныеОбъектовДляПечати("Документ.КоммерческоеПредложениеКлиенту",
		ИмяМакета,
		ОписаниеКоманды.ОбъектыПечати);
		
	ДвоичныеДанныеМакетов = МакетИДанныеОбъекта.Макеты.ДвоичныеДанныеМакетов;
	
	Секции = МакетИДанныеОбъекта.Макеты.ОписаниеСекций;
	
	Для Каждого ДокументСсылка Из ОписаниеКоманды.ОбъектыПечати Цикл
		
		ДанныеОбъекта = МакетИДанныеОбъекта.Данные[ДокументСсылка][ИмяМакета];
		
		Попытка
			
			ПечатнаяФорма = УправлениеПечатьюКлиент.ИнициализироватьПечатнуюФорму(ТипМакета);
			Макет = УправлениеПечатьюКлиент.ИнициализироватьМакетОфисногоДокумента(
				ДвоичныеДанныеМакетов[ИмяМакета], ТипМакета);
			
			// Вывод колонтитулов документа.
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета]["ВерхнийКолонтитул"]);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета]["НижнийКолонтитул"]);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].Заголовок);
			УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область, Ложь);
			УправлениеПечатьюКлиент.ЗаполнитьПараметры(ПечатнаяФорма, ДанныеОбъекта);
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.КонтактноеЛицо) Тогда
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].КонтактноеЛицо);
				УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область, Ложь);
				УправлениеПечатьюКлиент.ЗаполнитьПараметры(ПечатнаяФорма, ДанныеОбъекта);
			КонецЕсли;
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].Предложение);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ДанныеОбъекта.ЕстьСкидки Тогда
				ПостфиксСтрок = "";
			Иначе
				ПостфиксСтрок = "БезСкидки";
			КонецЕсли;
			
			ОбластьСтрокаТаблицыТоварыСтандарт    = Секции[ИмяМакета]["СтрокаТаблицаТовары" + ПостфиксСтрок];
			ОбластьШапкаТаблицыТовары             = Секции[ИмяМакета]["ШапкаТаблицаТовары"  + ПостфиксСтрок];
			
			//
			ДанныеОбъекта.вставить("ИспользоватьНаборы",Ложь);
			//
			
			Если ДанныеОбъекта.ИспользоватьНаборы Тогда
				ОбластьСтрокаТаблицыТоварыНабор              = Секции[ИмяМакета]["СтрокаТаблицаТовары"  + ПостфиксСтрок + "Набор"];
				ОбластьСтрокаТаблицыТоварыКомплектующие      = Секции[ИмяМакета]["СтрокаТаблицаТовары"  + ПостфиксСтрок + "Комплектующие"];
				ОбластьСтрокаТаблицыТоварыКомплектующиеКонец = Секции[ИмяМакета]["СтрокаТаблицаТовары"  + ПостфиксСтрок + "КомплектующиеКонец"];
			КонецЕсли;
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,ОбластьШапкаТаблицыТовары);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Индекс = 0;
			ВсегоСтрок = ДанныеОбъекта.Товары.Количество();
			Для Каждого СтрокаТЧ Из ДанныеОбъекта.Товары Цикл
				
				Индекс = Индекс + 1;
				
				Если НаборыКлиентСервер.ИспользоватьОбластьНабор(СтрокаТЧ, ДанныеОбъекта.ИспользоватьНаборы) Тогда
					ОбластьСтрокаТаблицыТовары = ОбластьСтрокаТаблицыТоварыНабор;
				ИначеЕсли НаборыКлиентСервер.ИспользоватьОбластьКомплектующие(СтрокаТЧ, ДанныеОбъекта.ИспользоватьНаборы) И Индекс < ВсегоСтрок Тогда
					ОбластьСтрокаТаблицыТовары = ОбластьСтрокаТаблицыТоварыКомплектующие;
				ИначеЕсли НаборыКлиентСервер.ИспользоватьОбластьКомплектующие(СтрокаТЧ, ДанныеОбъекта.ИспользоватьНаборы) Тогда
					ОбластьСтрокаТаблицыТовары = ОбластьСтрокаТаблицыТоварыКомплектующиеКонец;
				Иначе
					ОбластьСтрокаТаблицыТовары = ОбластьСтрокаТаблицыТоварыСтандарт;
				КонецЕсли;
				
				Масс = Новый Массив;
				Масс.Добавить(СтрокаТЧ);
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, ОбластьСтрокаТаблицыТовары);
				УправлениеПечатьюКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, Область, Масс, Ложь);
				
			КонецЦикла;
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ИтоговаяСтрока);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.СрокДействия) Тогда
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].СрокДействия);
				УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область, Ложь);
				УправлениеПечатьюКлиент.ЗаполнитьПараметры(ПечатнаяФорма, ДанныеОбъекта);
			КонецЕсли;
			
			//Если ЗначениеЗаполнено(ДанныеОбъекта.ГрафикОплаты)
			//	ИЛИ ЗначениеЗаполнено(ДанныеОбъекта.ФормаОплаты)
			//	ИЛИ ЗначениеЗаполнено(ДанныеОбъекта.Склад)
			//	ИЛИ ЗначениеЗаполнено(ДанныеОбъекта.ДополнительнаяИнформация) Тогда
			//	
			//	Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет,Секции[ИмяМакета].ЗаголовокДопИнформации);
			//	УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			//КонецЕсли;
			//
			//Если ЗначениеЗаполнено(ДанныеОбъекта.ГрафикОплаты) Тогда
			//	
			//	Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ГрафикОплаты);
			//	УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			//	
			//КонецЕсли;
			
			//Если ЗначениеЗаполнено(ДанныеОбъекта.ФормаОплаты) Тогда
			//	
			//	Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ФормаОплаты);
			//	УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			//	
			//КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.Склад) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].Склад);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			//Если ЗначениеЗаполнено(ДанныеОбъекта.ДополнительнаяИнформация) Тогда
			//	
			//	Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ДополнительнаяИнформация);
			//	УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			//	
			//КонецЕсли;
			
			Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].Подвал);
			УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.ТелефонОрганизации) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].ТелефонОрганизации);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеОбъекта.АдресЭлектроннойПочтыМенеджера) Тогда
				
				Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Секции[ИмяМакета].АдресЭлектроннойПочтыМенеджера);
				УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
				
			КонецЕсли;
			
			УправлениеПечатьюКлиент.ПоказатьДокумент(ПечатнаяФорма);
			
		Исключение
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма);
			УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
			
			Возврат Ложь;
			
		КонецПопытки;
		
		УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма, Ложь);
		УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
		
	КонецЦикла;
	
	Состояние(НСтр("ru = 'Формирование печатных форм завершено';
					|en = 'Print from generation is completed'"));
	
КонецФункции

