﻿// + [Rineco], [Шерстюк Ю.Ю.] [17.08.2021] 
// Задача: обновление 2.4.13.227 т.к. стоит ПродолжитьВызов, нет смысла вызова
// - [Rineco], [Шерстюк Ю.Ю.] [17.08.2021]

////&Вместо("ЗаполнитьЭтапыОплатыДокументаПродажиПоШаблону")
////Процедура Рин1_ЗаполнитьЭтапыОплатыДокументаПродажиПоШаблону(Объект, Знач СуммаКРаспределениюОплаты, Знач СуммаКРаспределениюЗалога, ШаблонГрафика, Знач Календарь)
////	// Вставить содержимое метода.
////	ПродолжитьВызов(Объект, СуммаКРаспределениюОплаты, СуммаКРаспределениюЗалога, ШаблонГрафика, Календарь);
////	
////	//ЭтапыГрафикаОплаты = Новый ТаблицаЗначений();
////	//
////	//ЭтапыГрафикаОплаты.Колонки.Добавить("ВариантОплаты");
////	//ЭтапыГрафикаОплаты.Колонки.Добавить("ДатаПлатежа");
////	//ЭтапыГрафикаОплаты.Колонки.Добавить("ПроцентПлатежа");
////	//ЭтапыГрафикаОплаты.Колонки.Добавить("СуммаПлатежа");
////	//ЭтапыГрафикаОплаты.Колонки.Добавить("ПроцентЗалогаЗаТару");
////	//ЭтапыГрафикаОплаты.Колонки.Добавить("СуммаЗалогаЗаТару");
////	//ЭтапыГрафикаОплаты.Колонки.Добавить("Сдвиг");

////	//////<++ Гигабайт Казаков М.В. Расчет этапов графика оплаты
////	////ЭтапыГрафикаОплаты.Колонки.Добавить("ГИГ_Сдвиг");
////	////ЭтапыГрафикаОплаты.Колонки.Добавить("ГИГ_ПроцентПлатежаРасчетный");
////	//////++> Гигабайт Казаков М.В.
////	//РаспределеннаяСуммаОплаты = 0;
////	//РаспределеннаяСуммаЗалога = 0;
////	//ТекущийЭтап               = 0;
////	//ОдинДень                  = 86400;
////	//
////	//КоличествоЭтапов = ШаблонГрафика.Количество();
////	//
////	//ДатаДокумента = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса());
////	//ЖелаемаяДатаОтгрузки = ?(ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Объект, "ЖелаемаяДатаОтгрузки"), 
////	//	Объект.ЖелаемаяДатаОтгрузки, Неопределено);
////	//НеОтгружатьЧастями = ?(ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Объект, "НеОтгружатьЧастями"),Объект.НеОтгружатьЧастями,Ложь);
////	//ЖелаемаяДатаОтгрузки = ?(ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Объект, "ДатаОтгрузки") И НеОтгружатьЧастями, 
////	//	Объект.ДатаОтгрузки, ЖелаемаяДатаОтгрузки);
////	//ДатаРеализации = ЖелаемаяДатаОтгрузки;
////	//
////	//// Определим календарную дату для каждого этапа графика оплаты
////	//УчитыватьКалендарь = Ложь;
////	//
////	//Если ЗначениеЗаполнено(Календарь) Тогда
////	//	
////	//	УчитыватьКалендарь = Истина;
////	//	
////	//	СдвигиАвансовыхЭтапов = Новый Массив();
////	//	СдвигиКредитныхЭтапов = Новый Массив();
////	//	МассивДатПоКалендарю  = Новый Массив();
////	//	
////	//	Для Каждого Этап Из ШаблонГрафика Цикл
////	//		
////	//		Если Этап.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки Или
////	//			Этап.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.АвансДоОбеспечения Тогда
////	//			СдвигиАвансовыхЭтапов.Добавить(Этап.Сдвиг);
////	//		Иначе
////	//			СдвигиКредитныхЭтапов.Добавить(Этап.Сдвиг);
////	//		КонецЕсли;
////	//		
////	//	КонецЦикла;
////	//	
////	//	Если СдвигиАвансовыхЭтапов.Количество() > 0 Тогда
////	//		
////	//		МассивДатПоКалендарюАвансовыхЭтапов = КалендарныеГрафики.ДатыПоКалендарю(Календарь, ДатаДокумента, СдвигиАвансовыхЭтапов);
////	//		
////	//		Для Каждого ДатаПоКалендарю Из МассивДатПоКалендарюАвансовыхЭтапов Цикл
////	//			МассивДатПоКалендарю.Добавить(ДатаПоКалендарю);
////	//		КонецЦикла;
////	//		
////	//	КонецЕсли;
////	//	
////	//	Если СдвигиКредитныхЭтапов.Количество() > 0 Тогда
////	//		
////	//		Если Не ЗначениеЗаполнено(ДатаРеализации) Тогда
////	//			
////	//			Если СдвигиАвансовыхЭтапов.Количество() > 0 Тогда
////	//				Если МассивДатПоКалендарюАвансовыхЭтапов.Количество() > 0 Тогда
////	//					ДатаРеализации = МассивДатПоКалендарюАвансовыхЭтапов[МассивДатПоКалендарюАвансовыхЭтапов.Количество()-1];
////	//				КонецЕсли;
////	//			Иначе
////	//				ДатаРеализации = ДатаДокумента;
////	//			КонецЕсли;
////	//			
////	//		КонецЕсли;
////	//		
////	//		МассивДатПоКалендарюКредитныхЭтапов = КалендарныеГрафики.ДатыПоКалендарю(Календарь, ДатаРеализации, СдвигиКредитныхЭтапов);
////	//		
////	//		Для Каждого ДатаПоКалендарю Из МассивДатПоКалендарюКредитныхЭтапов Цикл
////	//			МассивДатПоКалендарю.Добавить(ДатаПоКалендарю);
////	//		КонецЦикла;
////	//		
////	//	КонецЕсли;
////	//	
////	//Иначе
////	//	
////	//	Если Не ЗначениеЗаполнено(ДатаРеализации) Тогда
////	//		
////	//		МаксСдвигАванса = 0;
////	//	
////	//		Для Каждого ТекЭтап Из ШаблонГрафика Цикл
////	//			
////	//			Если ТекЭтап.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки Или
////	//				ТекЭтап.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.АвансДоОбеспечения Тогда
////	//				
////	//				МаксСдвигАванса = Макс(МаксСдвигАванса, ТекЭтап.Сдвиг);
////	//				
////	//			КонецЕсли;
////	//			
////	//		КонецЦикла;
////	//		
////	//		ДатаРеализации = ДатаДокумента + МаксСдвигАванса * ОдинДень;
////	//		
////	//	КонецЕсли;
////	//	
////	//КонецЕсли;
////	//
////	//// Определим последний незалоговый этап
////	//ПоследнийНезалоговыйЭтап = КоличествоЭтапов;
////	//Пока ПоследнийНезалоговыйЭтап <> 0 И ШаблонГрафика[ПоследнийНезалоговыйЭтап-1].ПроцентПлатежа = 0 Цикл
////	//	ПоследнийНезалоговыйЭтап = ПоследнийНезалоговыйЭтап - 1;
////	//КонецЦикла;
////	//
////	//// Определим последний залоговый этап
////	//ПоследнийЗалоговыйЭтап = КоличествоЭтапов;
////	//Пока ПоследнийЗалоговыйЭтап <> 0 И ШаблонГрафика[ПоследнийЗалоговыйЭтап-1].ПроцентЗалогаЗаТару = 0 Цикл
////	//	ПоследнийЗалоговыйЭтап = ПоследнийЗалоговыйЭтап - 1;
////	//КонецЦикла;
////	//
////	//// Заполним этапы в соответствии с графиком оплаты
////	//Объект.ЭтапыГрафикаОплаты.Очистить();
////	//Для Каждого Этап Из ШаблонГрафика Цикл
////	//	
////	//	ТекущийЭтап                     = ТекущийЭтап + 1;
////	//	ЭтапГрафикаОплаты               = ЭтапыГрафикаОплаты.Добавить();
////	//	ЭтапГрафикаОплаты.ВариантОплаты = Этап.ВариантОплаты;
////	//	
////	//	Если УчитыватьКалендарь Тогда
////	//		ДатаПлатежа = МассивДатПоКалендарю[ТекущийЭтап-1];
////	//	Иначе
////	//		ДатаПлатежа = ?(ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.КредитПослеОтгрузки
////	//						ИЛИ ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.КредитСдвиг, ДатаРеализации, ДатаДокумента) + Этап.Сдвиг * ОдинДень;
////	//	КонецЕсли;
////	//	
////	//	Если (ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки
////	//		Или ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.АвансДоОбеспечения)
////	//		И ЗначениеЗаполнено(ЖелаемаяДатаОтгрузки)
////	//		И ДатаПлатежа > ЖелаемаяДатаОтгрузки Тогда
////	//		ДатаПлатежа = ЖелаемаяДатаОтгрузки;
////	//	КонецЕсли;
////	//	
////	//	Если ЭтапГрафикаОплаты.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.КредитСдвиг Тогда
////	//		ЭтапГрафикаОплаты.Сдвиг           = Этап.Сдвиг;
////	//	КонецЕсли;
////	//	
////	//	ЭтапГрафикаОплаты.ДатаПлатежа         = ДатаПлатежа;
////	//	ЭтапГрафикаОплаты.ПроцентПлатежа      = Этап.ПроцентПлатежа;
////	//	СуммаОплатыПоЭтапу                    = Окр(СуммаКРаспределениюОплаты * Этап.ПроцентПлатежа / 100, 2, РежимОкругления.Окр15как20);
////	//	ЭтапГрафикаОплаты.СуммаПлатежа        = ?(ТекущийЭтап = ПоследнийНезалоговыйЭтап, СуммаКРаспределениюОплаты - РаспределеннаяСуммаОплаты, СуммаОплатыПоЭтапу);
////	//	РаспределеннаяСуммаОплаты             = РаспределеннаяСуммаОплаты + ЭтапГрафикаОплаты.СуммаПлатежа;
////	//	ЭтапГрафикаОплаты.ПроцентЗалогаЗаТару = Этап.ПроцентЗалогаЗаТару;
////	//	СуммаЗалогаПоЭтапу                    = Окр(СуммаКРаспределениюЗалога * Этап.ПроцентЗалогаЗаТару / 100, 2, РежимОкругления.Окр15как20);
////	//	ЭтапГрафикаОплаты.СуммаЗалогаЗаТару   = ?(ТекущийЭтап = ПоследнийЗалоговыйЭтап, СуммаКРаспределениюЗалога - РаспределеннаяСуммаЗалога, СуммаЗалогаПоЭтапу);
////	//	РаспределеннаяСуммаЗалога             = РаспределеннаяСуммаЗалога + ЭтапГрафикаОплаты.СуммаЗалогаЗаТару;
////	//	
////	//	////<++ Гигабайт Казаков М.В. Расчет этапов графика оплаты
////	//	//ДопДанные = Новый Структура("ГИГ_Сдвиг,ГИГ_ПроцентПлатежаРасчетный",Этап.Сдвиг,Этап.ПроцентПлатежа);
////	//	//ЗаполнитьЗначенияСвойств(ЭтапГрафикаОплаты,ДопДанные);
////	//	////++> Гигабайт Казаков М.В.
////	//КонецЦикла;
////	//
////	//ЭтапыГрафикаОплаты.Сортировать("ДатаПлатежа");
////	//Объект.ЭтапыГрафикаОплаты.Загрузить(ЭтапыГрафикаОплаты);
////	
////КонецПроцедуры

&Вместо("ЗаполнитьЭтапыОплатыДокументаПоЗаказам")
Процедура Рин1_ЗаполнитьЭтапыОплатыДокументаПоЗаказам(Параметры)
	Запрос   = Новый Запрос;
	Менеджер = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = Менеджер;
	
	СформироватьВТСуммЭтаповПоЗаказам(Запрос, Параметры);
	
	ТекстВТ = "
	|ВЫБРАТЬ
	|	ЗаказыКлиентов.Ссылка КАК Заказ,
	|	ЗаказыКлиентов.Сдвиг КАК Сдвиг,
	|	ЗаказыКлиентов.ВариантОплаты КАК ВариантОплаты,
	|	ЗаказыКлиентов.ДатаПлатежа КАК ДатаПлатежа,
	|	ЗаказыКлиентов.СуммаПлатежа КАК СуммаПлатежа,
	|	ЗаказыКлиентов.СуммаЗалогаЗаТару КАК СуммаЗалогаЗаТару,
	//++Шерстюк Ю.Ю. 21.01.21 определяем приоритет выбора графика сначала из заказа, если нет то из договора или соглашения
	//|	ЕСТЬNULL(ЗаказыКлиентов.Ссылка.Соглашение.ГрафикОплаты.Календарь,
	//|		ЕСТЬNULL(ЗаказыКлиентов.Ссылка.Соглашение.Календарь, 
	//|			ЗНАЧЕНИЕ(Справочник.ПроизводственныеКалендари.ПустаяСсылка))) КАК Календарь
	|	ЕСТЬNULL(ЗаказыКлиентов.Ссылка.ГрафикОплаты.Календарь,
	|		ЕСТЬNULL(ЗаказыКлиентов.Ссылка.Договор.ГрафикОплаты.Календарь,
	|         ЕСТЬNULL(ЗаказыКлиентов.Ссылка.Соглашение.ГрафикОплаты.Календарь,
	|			ЗНАЧЕНИЕ(Справочник.ПроизводственныеКалендари.ПустаяСсылка)))) КАК Календарь
	//--Шерстюк Ю.Ю.
	|ПОМЕСТИТЬ ВтЭтапы
	|ИЗ
	|	Документ.ЗаказКлиента.ЭтапыГрафикаОплаты КАК ЗаказыКлиентов
	|ГДЕ
	|	ЗаказыКлиентов.Ссылка В (&СписокЗаказов)
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	Заявки.Ссылка КАК Заказ,
	|	Заявки.Сдвиг КАК Сдвиг,
	|	Заявки.ВариантОплаты КАК ВариантОплаты,
	|	Заявки.ДатаПлатежа КАК ДатаПлатежа,
	|	Заявки.СуммаПлатежа КАК СуммаПлатежа,
	|	Заявки.СуммаЗалогаЗаТару КАК СуммаЗалогаЗаТару,
	|	ЕСТЬNULL(Заявки.Ссылка.Соглашение.ГрафикОплаты.Календарь,
	|		ЕСТЬNULL(Заявки.Ссылка.Соглашение.Календарь, 
	|			ЗНАЧЕНИЕ(Справочник.ПроизводственныеКалендари.ПустаяСсылка))) КАК Календарь
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЭтапыГрафикаОплаты КАК Заявки
	|ГДЕ
	|	Заявки.Ссылка В (&СписокЗаказов)
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	ЗаказыПоставщикам.Ссылка КАК Заказ,
	|	ЗаказыПоставщикам.Сдвиг КАК Сдвиг,
	|	ЗаказыПоставщикам.ВариантОплаты КАК ВариантОплаты,
	|	ЗаказыПоставщикам.ДатаПлатежа КАК ДатаПлатежа,
	|	ЗаказыПоставщикам.СуммаПлатежа КАК СуммаПлатежа,
	|	ЗаказыПоставщикам.СуммаЗалогаЗаТару КАК СуммаЗалогаЗаТару,
	|	ЕСТЬNULL(ЗаказыПоставщикам.Ссылка.Соглашение.Календарь, 
	|		ЗНАЧЕНИЕ(Справочник.ПроизводственныеКалендари.ПустаяСсылка)) КАК Календарь
	|ИЗ
	|	Документ.ЗаказПоставщику.ЭтапыГрафикаОплаты КАК ЗаказыПоставщикам
	|ГДЕ
	|	ЗаказыПоставщикам.Ссылка В (&СписокЗаказов)";
	
	//++ НЕ УТКА
	ТекстВТ = ТекстВТ + "
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	ЗаказДавальца.Ссылка КАК Заказ,
	|	ЗаказДавальца.Сдвиг КАК Сдвиг,
	|	ЗаказДавальца.ВариантОплаты КАК ВариантОплаты,
	|	ЗаказДавальца.ДатаПлатежа КАК ДатаПлатежа,
	|	ЗаказДавальца.СуммаПлатежа КАК СуммаПлатежа,
	|	0 КАК СуммаЗалогаЗаТару,
	|	ЗНАЧЕНИЕ(Справочник.ПроизводственныеКалендари.ПустаяСсылка) КАК Календарь
	|ИЗ
	|	Документ.ЗаказДавальца.ЭтапыГрафикаОплаты КАК ЗаказДавальца
	|ГДЕ
	|	ЗаказДавальца.Ссылка В (&СписокЗаказов)
	|";
	//-- НЕ УТКА
	
	Запрос.Текст = ТекстВТ + "
	|ИНДЕКСИРОВАТЬ ПО
	|	Заказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Заказы.Заказ                                                      КАК Заказ,
	|	Заказы.СверхЗаказа                                                КАК СверхЗаказа,
	|	Заказы.СуммаПлатежа                                               КАК СуммаПлатежа,
	|	Заказы.СуммаВзаиморасчетов                                        КАК СуммаВзаиморасчетов,
	|	Заказы.СуммаЗалогаЗаТару                                          КАК СуммаЗалогаЗаТару,
	|	Заказы.СуммаВзаиморасчетовПоТаре                                  КАК СуммаВзаиморасчетовПоТаре,
	// + [Rineco], [Шерстюк Ю.Ю.] [17.08.2021] 
	// изменения без автора	
	
	//|	МАКСИМУМ(Этапы.Сдвиг)                                             КАК Сдвиг,
	//|	МАКСИМУМ(ЕСТЬNULL(ВЫБОР КОГДА Этапы.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитСдвиг)
	//|								ИЛИ Этапы.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыПоставщику.КредитСдвиг)
	//|			ТОГДА ДОБАВИТЬКДАТЕ(&ДатаОтгрузки, ДЕНЬ, Этапы.Сдвиг)
	//|		ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	//|	КОНЕЦ, &ДатаОтгрузки))                                             КАК ДатаПлатежаСдвиг,
	//|	МАКСИМУМ(ЕСТЬNULL(ВЫБОР КОГДА Этапы.ВариантОплаты <> ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитСдвиг)
	//|								И Этапы.ВариантОплаты <> ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыПоставщику.КредитСдвиг)
	//|			ТОГДА ВЫБОР КОГДА Этапы.ДатаПлатежа < &ДатаОтгрузки ТОГДА &ДатаОтгрузки ИНАЧЕ Этапы.ДатаПлатежа КОНЕЦ
	//|		ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	//|	КОНЕЦ, &ДатаОтгрузки))                                             КАК ДатаПлатежа,
	|	Этапы.Сдвиг														 КАК Сдвиг,
	|	ЕСТЬNULL(ВЫБОР
	|			КОГДА Этапы.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитСдвиг)
	|					ИЛИ Этапы.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыПоставщику.КредитСдвиг)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&ДатаОтгрузки, ДЕНЬ, Этапы.Сдвиг)
	|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|		КОНЕЦ, &ДатаОтгрузки)										 КАК ДатаПлатежаСдвиг,
	|	ЕСТЬNULL(ВЫБОР
	|			КОГДА Этапы.ВариантОплаты <> ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитСдвиг)
	|					И Этапы.ВариантОплаты <> ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыПоставщику.КредитСдвиг)
	|				ТОГДА ВЫБОР
	|						КОГДА Этапы.ДатаПлатежа < &ДатаОтгрузки
	|							ТОГДА &ДатаОтгрузки
	|						ИНАЧЕ Этапы.ДатаПлатежа
	|					КОНЕЦ
	|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|		КОНЕЦ, &ДатаОтгрузки)										 КАК ДатаПлатежа,
	
	// - [Rineco], [Шерстюк Ю.Ю.] [17.08.2021]
	|	ЕСТЬNULL(Этапы.Календарь, Неопределено)                            КАК Календарь
	|ИЗ ВТЗаказы КАК Заказы
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВтЭтапы КАК Этапы
	|		ПО Этапы.Заказ = Заказы.Заказ
	|			И (Этапы.СуммаПлатежа > 0 И Заказы.СуммаПлатежа > 0 
	|				ИЛИ Этапы.СуммаЗалогаЗаТару > 0 И Заказы.СуммаЗалогаЗаТару > 0)
	|ГДЕ
	|	Заказы.СуммаПлатежа <> 0 ИЛИ Заказы.СуммаЗалогаЗаТару <> 0
	|СГРУППИРОВАТЬ ПО
	|	Заказы.Заказ,
	|	Заказы.СуммаПлатежа,
	|	Заказы.СуммаВзаиморасчетов,
	|	Заказы.СуммаВзаиморасчетовПоТаре,
	|	Заказы.СуммаЗалогаЗаТару,
	|	Заказы.СверхЗаказа,
	|	ЕСТЬNULL(Этапы.Календарь, Неопределено)
	// + [Rineco], [Шерстюк Ю.Ю.] [17.08.2021] 
	// изменения без автора	
	|,
	|	Этапы.Сдвиг,
	|	ЕСТЬNULL(ВЫБОР
	|			КОГДА Этапы.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитСдвиг)
	|					ИЛИ Этапы.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыПоставщику.КредитСдвиг)
	|				ТОГДА ДОБАВИТЬКДАТЕ(&ДатаОтгрузки, ДЕНЬ, Этапы.Сдвиг)
	|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|		КОНЕЦ, &ДатаОтгрузки),
	|	ЕСТЬNULL(ВЫБОР
	|			КОГДА Этапы.ВариантОплаты <> ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыКлиентом.КредитСдвиг)
	|					И Этапы.ВариантОплаты <> ЗНАЧЕНИЕ(Перечисление.ВариантыОплатыПоставщику.КредитСдвиг)
	|				ТОГДА ВЫБОР
	|						КОГДА Этапы.ДатаПлатежа < &ДатаОтгрузки
	|							ТОГДА &ДатаОтгрузки
	|						ИНАЧЕ Этапы.ДатаПлатежа
	|					КОНЕЦ
	|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|		КОНЕЦ, &ДатаОтгрузки)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаПлатежаСдвиг
	//|УПОРЯДОЧИТЬ ПО
	//|	МАКСИМУМ(Этапы.ДатаПлатежа)    	
	// - [Rineco], [Шерстюк Ю.Ю.] [17.08.2021]

	|";
	
	ДатаОтгрузки = ?(Параметры.Дата=Дата(1,1,1), ТекущаяДатаСеанса(), Параметры.Дата);
	Запрос.УстановитьПараметр("СписокЗаказов", Параметры.ТабличнаяЧасть.ВыгрузитьКолонку(Параметры.ИмяПоляЗаказ));
	Запрос.УстановитьПараметр("ДатаОтгрузки", ДатаОтгрузки);
	УстановитьПривилегированныйРежим(Истина);
	Заказы = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Параметры.ЭтапыГрафикаОплаты.Очистить();
	
	Для Каждого СтрокаЗаказа Из Заказы Цикл
		НовСтр = Параметры.ЭтапыГрафикаОплаты.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, СтрокаЗаказа);
		
		Если СтрокаЗаказа.ДатаПлатежаСдвиг > СтрокаЗаказа.ДатаПлатежа Тогда
			Если ЗначениеЗаполнено(СтрокаЗаказа.Календарь) Тогда
				НовСтр.ДатаПлатежа = КалендарныеГрафики.ДатаПоКалендарю(СтрокаЗаказа.Календарь, ДатаОтгрузки, СтрокаЗаказа.Сдвиг);
			Иначе
				НовСтр.ДатаПлатежа = СтрокаЗаказа.ДатаПлатежаСдвиг;
			КонецЕсли;
		КонецЕсли;
		
		Если НовСтр.ДатаПлатежа < НачалоДня(Параметры.Дата) Тогда
			НовСтр.ДатаПлатежа = Параметры.Дата;
		КонецЕсли;
		
		Если СтрокаЗаказа.ДатаПлатежаСдвиг > СтрокаЗаказа.ДатаПлатежа Тогда
			Если Параметры.ИмяПоляЗаказ = "ЗаказПоставщику" Тогда
				НовСтр.ВариантОплаты = Перечисления.ВариантыОплатыПоставщику.КредитСдвиг;
			Иначе
				НовСтр.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.КредитСдвиг;
			КонецЕсли;
		Иначе
			Если Параметры.ИмяПоляЗаказ = "ЗаказПоставщику" Тогда
				НовСтр.ВариантОплаты = Перечисления.ВариантыОплатыПоставщику.КредитПослеПоступления;
			Иначе
				НовСтр.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.КредитПослеОтгрузки;
			КонецЕсли;
			НовСтр.Сдвиг = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьПроцентыПоСуммам(Параметры);
	
КонецПроцедуры
