﻿
&НаКлиенте
Процедура Рин1_ОформитьДокументы888НажатиеВместо(Элемент)
	// Вставить содержимое обработчика.
	Рин1_ОформитьДокументыНажатие999(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Рин1_ОформитьДокументыНажатие999(Форма)
	
	СтандартнаяОбработка = Ложь;
	
	Если Форма.Модифицированность Тогда
		
		Если Форма.Объект.Проведен Тогда
			СтрокаДействие = НСтр("ru = 'перепроведение';
									|en = 'reposting'");
		Иначе
			СтрокаДействие = НСтр("ru = 'запись';
									|en = 'record'");
		КонецЕсли;
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("Рин1_ОформитьДокументыНажатиеЗавершение999", ЭтотОбъект, Новый Структура("Форма", Форма));
		ТекстВопроса = СтрШаблон(НСтр("ru = 'Акт о расхождениях был изменен. Выполнить %1 документа?';
										|en = 'Discrepancy certificate was changed. %1 document?'"), СтрокаДействие);
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		Рин1_ОткрытьОформляемыеДокументы999(Форма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Рин1_ОформитьДокументыНажатиеЗавершение999(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	Форма.Записать();
	
	Если Не Форма.Модифицированность Тогда
		Рин1_ОткрытьОформляемыеДокументы999(Форма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Рин1_ОткрытьОформляемыеДокументы999(Форма)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АктОРасхождениях", Форма.Объект.Ссылка);
	ОткрытьФорму("Обработка.Рин1_РаботаСАктамиРасхождений.Форма.ОформляемыеДокументы", ПараметрыФормы, Форма);
	
КонецПроцедуры

&НаКлиенте
Процедура Рин1_ПриОткрытииПосле(Отказ)
	//Вставить содержимое обработчика
	Если ЭтотОбъект.Элементы.ОформитьДокументы.Гиперссылка = Истина Тогда
		ЭтотОбъект.Элементы.ОформитьДокументы888.Гиперссылка = Истина;
		ЭтотОбъект.Элементы.ОформитьДокументы888.Заголовок   = НСтр("ru = 'Оформить документы (Ринэко)';
															|en = 'Issue documents'");
	Иначе
		ЭтотОбъект.Элементы.ОформитьДокументы888.Гиперссылка = Ложь;
			ЭтотОбъект.Элементы.ОформитьДокументы888.Заголовок = НСтр("ru = 'Оформление документов доступно при указанном способе отражения и наличии расхождений в статусах ""Отрабатывается"" и ""Отработано""';
																|en = 'Document registration is available with the specified record method and if there are discrepancies in the ""Being processed"" and ""Processed"" statuses'");
	КонецЕсли;			
КонецПроцедуры

&НаСервере
Процедура Рин1_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	
	//bercut090620 Задача № 909
//{{20201228 ГлазуновДВ
	УстановитьПривилегированныйРежим(Истина);
//}}20201228 ГлазуновДВ
	
	Если (ТекущийОбъект.Статус = Перечисления.СтатусыАктаОРасхождениях.КВыполнению Или ТекущийОбъект.Статус = Перечисления.СтатусыАктаОРасхождениях.Отработано) и ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение и 
		ТекущийОбъект.СпособОтраженияРасхождений = Перечисления.СпособыОтраженияРасхожденийАктПриемкиКлиента.ОформлениеКорректировкиКакИсправлениеПервичныхДокументов Тогда
		
		ТЗ_Товары = Объект.Товары.Выгрузить();
		ТЗ_Товары.Свернуть("Реализация");
		
		Если ТЗ_Товары.Количество() = 0 или Не ТипЗнч(ТЗ_Товары[0].Реализация) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			Возврат;
		КонецЕсли;
		
		//техзадание предпологает создание 4-х обработчиков события
		Тз_Возврат = Новый ТаблицаЗначений;
		Тз_Возврат.Колонки.Добавить("НомерСтроки",Новый ОписаниеТипов("Число"));
		
		Тз_Допоставка = Новый ТаблицаЗначений;
		Тз_Допоставка.Колонки.Добавить("НомерСтроки",Новый ОписаниеТипов("Число"));
		
		Тз_Отгрузка = Новый ТаблицаЗначений;
		Тз_Отгрузка.Колонки.Добавить("НомерСтроки",Новый ОписаниеТипов("Число"));
		
		Тз_Приемка = Новый ТаблицаЗначений;
		Тз_Приемка.Колонки.Добавить("НомерСтроки",Новый ОписаниеТипов("Число"));
		
		Для каждого Строка Из Объект.Товары Цикл
			Если не ЗначениеЗаполнено(Строка.Действие) Тогда
				Продолжить;
			КонецЕсли;
			
			Если Строка.КоличествоУпаковокРасхождения < 0 и Строка.Действие = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ДопоставкаНеТребуется Тогда
				//1. Оформляем возврат на наш склад				
				НовСтр = Тз_Возврат.Добавить();
				НовСтр.НомерСтроки = Строка.НомерСтроки;
			ИначеЕсли Строка.КоличествоУпаковокРасхождения < 0 и Строка.Действие = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ТребуетсяДопоставка Тогда
				//2. Оформляем допоставку (х шт потерянные при транспортировке н-р. списываем на расходы)
				НовСтр = Тз_Допоставка.Добавить();
				НовСтр.НомерСтроки = Строка.НомерСтроки;
			ИначеЕсли Строка.КоличествоУпаковокРасхождения > 0 и Строка.Действие = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ПокупкаПерепоставленного Тогда
				//3. Оформляем отгрузку с нашего склада
				НовСтр = Тз_Отгрузка.Добавить();
				НовСтр.НомерСтроки = Строка.НомерСтроки;
//Исходное			ИначеЕсли Строка.КоличествоУпаковокРасхождения > 0 и Строка.Действие = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ОприходоватьСейчас Тогда
		//{{20210120 ГлазуновДВ
			ИначеЕсли Строка.КоличествоУпаковокРасхождения > 0 И
						(Строка.Действие = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ОприходоватьСейчас
						Или Строка.Действие = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ВозвратПерепоставленного)
						Тогда
		//}}20210120 ГлазуновДВ
				//4. Ожидаем приемку на наш склад (перепоставка, н-р ошибка оператора).
 				НовСтр = Тз_Приемка.Добавить();
				НовСтр.НомерСтроки = Строка.НомерСтроки;
			КонецЕсли;
		КонецЦикла;
		
		//обрабатывем события
		Если не Тз_Возврат.Количество() = 0 Тогда
			//1.
			НаборЗаписей = РегистрыНакопления.ТоварыКПоступлению.СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.Регистратор.Установить(ТекущийОбъект.Ссылка);
			
			Для каждого СтрокаТз Из Тз_Возврат Цикл
				МассивСтрок = Объект.Товары.НайтиСтроки(Новый Структура("НомерСтроки",СтрокаТз.НомерСтроки));
				Если не МассивСтрок.Количество() = 0 Тогда
					
					Запись = НаборЗаписей.ДобавитьПриход();
					Запись.Период = ТекущийОбъект.Дата;
					Запись.Регистратор = ТекущийОбъект.Ссылка;
					Запись.ДокументПоступления = ТекущийОбъект.Ссылка;
					Запись.Склад = МассивСтрок[0].Реализация.Склад;
					Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиента;
					Запись.Отправитель = МассивСтрок[0].Реализация.Партнер;
					Запись.Номенклатура = МассивСтрок[0].Номенклатура;
					Запись.КОформлениюОрдеров = МассивСтрок[0].КоличествоУпаковокРасхождения*-1;
					Запись.Назначение = МассивСтрок[0].Назначение;
					//НаборЗаписей.Записать(Ложь);
					
				КонецЕсли;
			КонецЦикла;
	//		
	//		НаборЗаписей = РегистрыНакопления.ТоварыОрганизаций.СоздатьНаборЗаписей(); 
	//		НаборЗаписей.Отбор.Регистратор.Установить(ТекущийОбъект.Ссылка);
	//		
	//		Для каждого СтрокаТз Из Тз_Возврат Цикл
	//			МассивСтрок = Объект.Товары.НайтиСтроки(Новый Структура("НомерСтроки",СтрокаТз.НомерСтроки));
	//			Если не МассивСтрок.Количество() = 0 Тогда
	//				
	//				Запись = НаборЗаписей.ДобавитьПриход();
	//				Запись.Период = ТекущийОбъект.Дата;
	//				Запись.Регистратор = ТекущийОбъект.Ссылка;
	//				Запись.Организация = МассивСтрок[0].Реализация.Организация.Ссылка;
	//				
	//						//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	//		// Данный фрагмент построен конструктором.
	//		// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	//		
	//		Запрос = Новый Запрос;
	//		Запрос.Текст = 
	//			"ВЫБРАТЬ
	//			|	КлючиАналитикиУчетаНоменклатуры.Ссылка КАК Ссылка
	//			|ИЗ
	//			|	Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитикиУчетаНоменклатуры
	//			|ГДЕ
	//			|	КлючиАналитикиУчетаНоменклатуры.Назначение = &СтрНазначение
	//			|	И КлючиАналитикиУчетаНоменклатуры.Номенклатура = &СтрНоменклатура
	//			|	И КлючиАналитикиУчетаНоменклатуры.МестоХранения = &СтрСклад";
	//		
	//		Запрос.УстановитьПараметр("СтрСклад", МассивСтрок[0].Склад);
	//		Запрос.УстановитьПараметр("СтрНазначение", МассивСтрок[0].Назначение);
	//		Запрос.УстановитьПараметр("СтрНоменклатура", МассивСтрок[0].Номенклатура);
	//		
	//		РезультатЗапроса = Запрос.Выполнить();
	//		
	//		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//		
	//		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//			// Вставить обработку выборки ВыборкаДетальныеЗаписи
	//		КонецЦикла;
	//		
	//		//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	//
	//				
	//				
	//				Запись.АналитикаУчетаНоменклатуры = ВыборкаДетальныеЗаписи.Ссылка;
	//				Запись.ВидЗапасов = Справочники.ВидыЗапасов.НайтиПоРеквизиту("Организация",МассивСтрок[0].Реализация.Организация);
	//				Запись.НомерГТД = "";
	//				Запись.ДокументРеализации = МассивСтрок[0].Реализация;
	//				Запись.Номенклатура = МассивСтрок[0].Номенклатура;
	//				Запись.Количество = МассивСтрок[0].КоличествоУпаковокРасхождения;
	//				НаборЗаписей.Записать(Ложь);
	//				
	//			КонецЕсли;
	//		КонецЦикла;
			
		КонецЕсли;
		
		Если не Тз_Допоставка.Количество() = 0 Тогда
			//2.
			НаборЗаписей = РегистрыНакопления.ТоварыКОтгрузке.СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.Регистратор.Установить(ТекущийОбъект.Ссылка);
			
			Для каждого СтрокаТз Из Тз_Допоставка Цикл
				МассивСтрок = Объект.Товары.НайтиСтроки(Новый Структура("НомерСтроки",СтрокаТз.НомерСтроки));
				Если не МассивСтрок.Количество() = 0 Тогда
					
					Запись = НаборЗаписей.ДобавитьПриход();
					Запись.Период = ТекущийОбъект.Дата;
					Запись.Регистратор = ТекущийОбъект.Ссылка;
					Запись.ДокументОтгрузки = ТекущийОбъект.Ссылка;
					Запись.Склад = МассивСтрок[0].Реализация.Склад;
			//		Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиента;
					Запись.Получатель = МассивСтрок[0].Реализация.Партнер;
					Запись.Номенклатура = МассивСтрок[0].Номенклатура;
					Запись.КОтгрузке = МассивСтрок[0].КоличествоУпаковокРасхождения*-1;
					Запись.Назначение = МассивСтрок[0].Назначение;
					//НаборЗаписей.Записать(Ложь);
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		Если не Тз_Отгрузка.Количество() = 0 Тогда
			//3.
			НаборЗаписей = РегистрыНакопления.ТоварыКОтгрузке.СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.Регистратор.Установить(ТекущийОбъект.Ссылка);
			
			Для каждого СтрокаТз Из Тз_Отгрузка Цикл
				МассивСтрок = Объект.Товары.НайтиСтроки(Новый Структура("НомерСтроки",СтрокаТз.НомерСтроки));
				Если не МассивСтрок.Количество() = 0 Тогда
					
					Запись = НаборЗаписей.ДобавитьПриход();
					Запись.Период = ТекущийОбъект.Дата;
					Запись.Регистратор = ТекущийОбъект.Ссылка;
					Запись.ДокументОтгрузки = ТекущийОбъект.Ссылка;
					Запись.Склад = МассивСтрок[0].Реализация.Склад;
			//		Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиента;
					Запись.Получатель = МассивСтрок[0].Реализация.Партнер;
					Запись.Номенклатура = МассивСтрок[0].Номенклатура;
					Запись.КОтгрузке = МассивСтрок[0].КоличествоУпаковокРасхождения;
					Запись.Назначение = МассивСтрок[0].Назначение;
					НаборЗаписей.Записать(Ложь);
					
				КонецЕсли;
			КонецЦикла;
			
//20210120 ГлазуновДВ ПОЛНОСТЬЮ ОТКЛЮЧИЛИ			
			//НаборЗаписей = РегистрыНакопления.ТоварыОрганизаций.СоздатьНаборЗаписей(); 
			//НаборЗаписей.Отбор.Регистратор.Установить(ТекущийОбъект.Ссылка);
			//
			//Для каждого СтрокаТз Из Тз_Отгрузка Цикл
			//	МассивСтрок = Объект.Товары.НайтиСтроки(Новый Структура("НомерСтроки",СтрокаТз.НомерСтроки));
			//	Если не МассивСтрок.Количество() = 0 Тогда
			//		
			//		Запись = НаборЗаписей.ДобавитьПриход();
			//		Запись.Период = ТекущийОбъект.Дата;
			//		Запись.Регистратор = ТекущийОбъект.Ссылка;
			//		Запись.Организация = МассивСтрок[0].Реализация.Организация;
			//		
			//							//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
			//			// Данный фрагмент построен конструктором.
			//			// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
			//			
			//			Запрос = Новый Запрос;
			//			Запрос.Текст = 
			//				"ВЫБРАТЬ
			//				|	КлючиАналитикиУчетаНоменклатуры.Ссылка КАК Ссылка
			//				|ИЗ
			//				|	Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитикиУчетаНоменклатуры
			//				|ГДЕ
			//				|	КлючиАналитикиУчетаНоменклатуры.Назначение = &СтрНазначение
			//				|	И КлючиАналитикиУчетаНоменклатуры.Номенклатура = &СтрНоменклатура
			//				|	И КлючиАналитикиУчетаНоменклатуры.МестоХранения = &СтрСклад";
			//			
			//			Запрос.УстановитьПараметр("СтрСклад", МассивСтрок[0].Склад);
			//			Запрос.УстановитьПараметр("СтрНазначение", МассивСтрок[0].Назначение);
			//			Запрос.УстановитьПараметр("СтрНоменклатура", МассивСтрок[0].Номенклатура);
			//			
			//			РезультатЗапроса = Запрос.Выполнить();
			//			
			//			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			//			
			//			ВыборкаДетальныеЗаписи.Следующий();
			//			
			//			//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
			//		
			//		Запись.АналитикаУчетаНоменклатуры = ВыборкаДетальныеЗаписи.Ссылка;
			//		Запись.ВидЗапасов = Справочники.ВидыЗапасов.НайтиПоРеквизиту("Организация",МассивСтрок[0].Реализация.Организация);
			//		
			//			Запрос = Новый Запрос;
			//			Запрос.Текст = 
			//				"ВЫБРАТЬ
			//				|	ДанныеРегистра.Номенклатура КАК Номенклатура,
			//				|	МАКСИМУМ(ДанныеРегистра.ДатаПоступления) КАК ДатаПоступления,
			//				|	МАКСИМУМ(ДанныеРегистра.НомерГТД) КАК НомерГТД
			//				|	
			//				|ИЗ
			//				|	РегистрСведений.ДатыПоступленияТоваровОрганизаций КАК ДанныеРегистра
			//				|ГДЕ
			//				|	ДанныеРегистра.НомерГТД <> ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
			//				|   И ДанныеРегистра.Номенклатура = &Номенклатура
			//				|
			//				|СГРУППИРОВАТЬ ПО
			//				|	ДанныеРегистра.Номенклатура";
			//			Запрос.УстановитьПараметр("Номенклатура", МассивСтрок[0].Номенклатура);
			//			
			//			РезультатЗапроса = Запрос.Выполнить();
			//			
			//			ВыборкаДетальныеЗаписиГТД = РезультатЗапроса.Выбрать();
			//			
			//			ВыборкаДетальныеЗаписиГТД.Следующий();
			//		
			//		Запись.НомерГТД = ВыборкаДетальныеЗаписиГТД.НомерГТД;
			//		
			//		Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.КорректировкаПоСогласованиюСторон;
			//		Запись.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
			//		Запись.КорАналитикаУчетаНоменклатуры = ВыборкаДетальныеЗаписи.Ссылка;
			//		Запись.КорВидЗапасов = Справочники.ВидыЗапасов.НайтиПоРеквизиту("Организация",МассивСтрок[0].Реализация.Организация);
			//		Запись.ОрганизацияОтгрузки = МассивСтрок[0].Реализация.Организация;
			//		
			//		Запись.ДокументРеализации = МассивСтрок[0].Реализация;
			//		Запись.Номенклатура = МассивСтрок[0].Номенклатура;
			//		Запись.Количество = МассивСтрок[0].КоличествоУпаковокРасхождения;
			//		НаборЗаписей.Записать(Ложь);
			//		
			//	КонецЕсли;
			//КонецЦикла;
			
		КонецЕсли;
		
		Если не Тз_Приемка.Количество() = 0 Тогда
			//4.
			НаборЗаписей = РегистрыНакопления.ТоварыКПоступлению.СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.Регистратор.Установить(ТекущийОбъект.Ссылка);
			
			Для каждого СтрокаТз Из Тз_Приемка Цикл
				МассивСтрок = Объект.Товары.НайтиСтроки(Новый Структура("НомерСтроки",СтрокаТз.НомерСтроки));
				Если не МассивСтрок.Количество() = 0 Тогда
					
					Запись = НаборЗаписей.ДобавитьПриход();
					Запись.Период = ТекущийОбъект.Дата;
					Запись.Регистратор = ТекущийОбъект.Ссылка;
					Запись.ДокументПоступления = ТекущийОбъект.Ссылка;
					Запись.Склад = МассивСтрок[0].Реализация.Склад;
					Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиента;
					Запись.Отправитель = МассивСтрок[0].Реализация.Партнер;
					Запись.Номенклатура = МассивСтрок[0].Номенклатура;
					Запись.КОформлениюОрдеров = МассивСтрок[0].КоличествоУпаковокРасхождения;
					Запись.Назначение = МассивСтрок[0].Назначение;
					//Запись.Рин1_АктОРасхожденияхОтключитьДвижение = Истина;
					НаборЗаписей.Записать(Ложь);
					
					//++Шерстюк Ю.Ю. 24.02.2021 по задаче 5825 должно быть еще одно движение, оно раньше было, но в результате изменений логики исчезло.
					//вариант допроведения в этой процедуре нужно переделывать по примеру типового проведения: Формируем таблицы Движений и проводим типовым способом
					//пока исправляем здесь, до пересмотра логики или перехода на 2.5
					Запись = НаборЗаписей.ДобавитьРасход();
					Запись.Период = ТекущийОбъект.Дата;
					Запись.Регистратор = ТекущийОбъект.Ссылка;
					Запись.ДокументПоступления = ТекущийОбъект.Ссылка;
					Запись.Склад = МассивСтрок[0].Реализация.Склад;
					Запись.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиента;
					Запись.Отправитель = МассивСтрок[0].Реализация.Партнер;
					Запись.Номенклатура = МассивСтрок[0].Номенклатура;
					Запись.КОформлениюПоступленийПоОрдерам = МассивСтрок[0].КоличествоУпаковокРасхождения;
					Запись.Назначение = МассивСтрок[0].Назначение;
					//Запись.Рин1_АктОРасхожденияхОтключитьДвижение = Истина;
					НаборЗаписей.Записать(Ложь);
					//--Шерстюк Ю.Ю.
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
//{{20201228 ГлазуновДВ
	УстановитьПривилегированныйРежим(Ложь);
//}}20201228 ГлазуновДВ
	//
	
КонецПроцедуры


&НаКлиенте
Процедура Рин1_СпособОтраженияРасхожденийПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ЭтотОбъект.Элементы.ОформитьДокументы888.Доступность = Ложь;
	Если Элемент.Имя = "СпособОтраженияРасхожденийКорректировкаИсправление" Тогда
		ЭтотОбъект.Элементы.ОформитьДокументы888.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

//20200817 ГлазуновДВ Вставили отмену проверки по дате запрета и возможность записывать без перепроведения
&НаСервере
&После("ПриЧтенииНаСервере")
Процедура Рин1_ПриЧтенииНаСервере(ТекущийОбъект)
	// Вставить содержимое метода.
	//ТекущийОбъект.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
	//ЭтаФорма.ПриЗаписиПерепроводить = Ложь;
//{{20201204 ГлазуновДВ
	Если ЭтаФорма.ТолькоПросмотр = Истина Тогда
		ЭтаФорма.ТолькоПросмотр = Ложь;
		Для Каждого СтрокаЭлементы Из ЭтаФорма.Элементы Цикл
			Если ТипЗнч(СтрокаЭлементы) = Тип("ПолеФормы") Или ТипЗнч(СтрокаЭлементы) = Тип("КнопкаФормы") Тогда
				 СтрокаЭлементы.Доступность = Ложь;
			КонецЕсли;
		КонецЦикла;
		ЭтаФорма.Элементы.Статус.Доступность = Истина;
		ЭтаФорма.Элементы.ФормаЗаписать.Доступность = Истина;
		ЭтаФорма.Элементы.ГруппаТоварыЗаполнить.Доступность = Ложь;
		ЭтаФорма.Элементы.ОформитьДокументы888.Доступность = Ложь;
	КонецЕсли;
//}}20201204 ГлазуновДВ	
КонецПроцедуры

//{{20201204 ГлазуновДВ
&НаСервере
&После("ПередЗаписьюНаСервере")
Процедура Рин1_ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Вставить содержимое метода.
	
		Если ЭтаФорма.Элементы.ФормаПровестиИЗакрыть.Доступность = Ложь Тогда
			ТекущийОбъект.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
		КонецЕсли;
КонецПроцедуры

&НаКлиенте
&Вместо("СтатусПриИзменении")
Процедура Рин1_СтатусПриИзменении(Элемент)
	//Вставить содержимое обработчика
	
	СтатусВСсылке = ПолучениеСтатусВСсылке();
	Если Не ЭтаФорма.Элементы.ФормаПровестиИЗакрыть.Доступность Тогда
		Если (СтатусВСсылке = ПредопределенноеЗначение("Перечисление.СтатусыАктаОРасхождениях.Отработано")
			ИЛИ СтатусВСсылке = ПредопределенноеЗначение("Перечисление.СтатусыАктаОРасхождениях.Рин1_Отказано"))
			И
			(Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыАктаОРасхождениях.НеСогласовано")
			ИЛИ Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыАктаОРасхождениях.Согласовано")
			ИЛИ Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыАктаОРасхождениях.КВыполнению")) Тогда
			Сообщить("Отсутствует право на изменение статуса. Обратитесь к пользователю с полными правами!");
			Объект.Статус = СтатусВСсылке;
			Возврат;
		ИначеЕсли СтатусВСсылке = ПредопределенноеЗначение("Перечисление.СтатусыАктаОРасхождениях.КВыполнению")
			И
			(Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыАктаОРасхождениях.НеСогласовано")
			ИЛИ Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыАктаОРасхождениях.Согласовано")) Тогда
			Сообщить("Отсутствует право на изменение статуса. Обратитесь к пользователю с полными правами!");
			Объект.Статус = СтатусВСсылке;
			Возврат;
		ИначеЕсли СтатусВСсылке = ПредопределенноеЗначение("Перечисление.СтатусыАктаОРасхождениях.Согласовано")
			И
			Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыАктаОРасхождениях.НеСогласовано") Тогда
			Сообщить("Отсутствует право на изменение статуса. Обратитесь к пользователю с полными правами!");
			Объект.Статус = СтатусВСсылке;
			Возврат;
		КонецЕсли;
	Иначе	
		РасхожденияКлиентСервер.УправлениеДоступностью(ЭтотОбъект);
		
		Если ЭтотОбъект.Элементы.ОформитьДокументы.Гиперссылка = Истина Тогда
			ЭтотОбъект.Элементы.ОформитьДокументы888.Гиперссылка = Истина;
			ЭтотОбъект.Элементы.ОформитьДокументы888.Заголовок   = НСтр("ru = 'Оформить документы (Ринэко)';
																|en = 'Issue documents'");
		Иначе
			ЭтотОбъект.Элементы.ОформитьДокументы888.Гиперссылка = Ложь;
				ЭтотОбъект.Элементы.ОформитьДокументы888.Заголовок = НСтр("ru = 'Оформление документов доступно при указанном способе отражения и наличии расхождений в статусах ""Отрабатывается"" и ""Отработано""';
																	|en = 'Document registration is available with the specified record method and if there are discrepancies in the ""Being processed"" and ""Processed"" statuses'");
		КонецЕсли;			
	КонецЕсли;			
КонецПроцедуры

&НаСервере
Функция ПолучениеСтатусВСсылке()
	Возврат Объект.Ссылка.Статус; 
КонецФункции

//}}20201204 ГлазуновДВ

&НаСервере
Процедура Рин1_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	//++Шерстюк Ю.Ю. Задача 7625 менеджер и подразделение по договору
	Если РольДоступна("Рин1_РедактированиеРеализации") или РольДоступна("ПолныеПрава") Тогда	
		Элементы.Менеджер.ТолькоПросмотр = Ложь;
		Элементы.Подразделение.ТолькоПросмотр = Ложь;
	Иначе
        Элементы.Менеджер.ТолькоПросмотр = Истина;
		Элементы.Подразделение.ТолькоПросмотр = Истина;
	КонецЕсли;
	//--Шерстюк Ю.Ю.

КонецПроцедуры


&НаКлиенте
Процедура Рин1_ДоговорПриИзмененииПосле(Элемент)
	//++Шерстюк Ю.Ю. Задача 7625 менеджер и подразделение по договору
	Если ЗначениеЗаполнено(Объект.Договор) Тогда 
		Объект.Менеджер = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Объект.Договор,"Менеджер");
		Объект.Подразделение = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Объект.Договор,"Подразделение"); 
	КонецЕсли;
	//--Шерстюк Ю.Ю.

КонецПроцедуры

&НаСервере
&После("КлиентПриИзмененииНаСервере")
Процедура Рин1_КлиентПриИзмененииНаСервере()
	//++Шерстюк Ю.Ю. Задача 7625 менеджер и подразделение по договору
	Если ЗначениеЗаполнено(Объект.Договор) Тогда 
		Объект.Менеджер = Объект.Договор.Менеджер;
		Объект.Подразделение = Объект.Договор.Подразделение; 
	КонецЕсли;
	//--Шерстюк Ю.Ю.
КонецПроцедуры
