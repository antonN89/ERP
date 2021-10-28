﻿
&НаСервере
Процедура ПодключитьДополнительныеЭлементыФормы()
	
	Группа = Элементы.Добавить("ГруппаКонтрольОбеспечения",Тип("ГруппаФормы"),Элементы.ГруппаРасчетыЛевая);
	Группа.Заголовок = "Ограничивать обеспечение заказов:";
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	Элементы.Переместить(Группа,Элементы.ГруппаРасчетыЛевая,Элементы.ГруппаОплатаЗаСчетСредствГОЗ);
	Элемент = Элементы.Добавить("ГИГ_ОграничиватьСуммуКОбеспечению",Тип("ПолеФормы"),Группа);
	Элемент.Вид= ВидПоляФормы.ПолеФлажка;
	Элемент.Заголовок = "при общей сумме позиций к обеспечению более";
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	Элемент.ПутьКДанным = "Объект.ГИГ_ОграничиватьСуммуКОбеспечению";
	Элемент = Элементы.Добавить("ГИГ_ДопустимаяСуммаКОбеспечению",Тип("ПолеФормы"),Группа);
	Элемент.Вид= ВидПоляФормы.ПолеВвода;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	Элемент.ПутьКДанным = "Объект.ГИГ_ДопустимаяСуммаКОбеспечению";
	
	//ГрафикОплаты
	Группа = Элементы.Добавить("ГруппаГрафикОплаты",Тип("ГруппаФормы"),Элементы.ГруппаРасчетыЛевая);
	Группа.Заголовок = "График оплаты";
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	Элемент = Элементы.Добавить("ГрафикОплаты",Тип("ПолеФормы"),Группа);
	Элемент.Вид= ВидПоляФормы.ПолеВвода;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	Элемент.ПутьКДанным = "Объект.ГрафикОплаты";
	Элемент.АвтоОтметкаНезаполненного = Истина;

//{{20200831 ГлазуновДВ (Задача № 2363)
	//Отгрузка без перехода права собственности
	Элемент = Элементы.Добавить("ВозможнаРеализацияБезПереходаПраваСобственности",Тип("ПолеФормы"),Группа);
	Элемент.Вид = ВидПоляФормы.ПолеФлажка;
	Элемент.Заголовок = "Возможна отгрузка без перехода права собственности";
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	Элемент.ПутьКДанным = "Объект.Рин1_ВозможнаРеализацияБезПереходаПраваСобственности";
	Элемент.УстановитьДействие("ПриИзменении","Рин1_ВозможнаРеализацияБезПереходаПраваСобственностиПриИзменении");
	
	ГруппаУчетаДней = Элементы.Добавить("ГруппаУчетаДней",Тип("ГруппаФормы"),Группа);
	ГруппаУчетаДней.Заголовок = "Группа учета дней";
	ГруппаУчетаДней.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаУчетаДней.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	ГруппаУчетаДней.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	ГруппаУчетаДней.ОтображатьЗаголовок = Ложь;
	Элемент = Элементы.Добавить("СрокДоставки",Тип("ПолеФормы"),ГруппаУчетаДней);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.Заголовок = "Срок доставки, в днях";
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
	Элемент.КнопкаРегулирования	= Истина;
	//Элемент.РастягиватьПоГоризонтали = Истина;
	Элемент.ПутьКДанным = "Объект.Рин1_СрокДоставки";
	
	Элемент = Элементы.Добавить("ДниРабочие",Тип("ПолеФормы"),ГруппаУчетаДней);
	Элемент.Вид = ВидПоляФормы.ПолеПереключателя;
	//Элемент.Вид = ВидПоляФормы.ПолеВвода;
	//Элемент.СписокВыбора.Добавить(Истина, "В календарных днях");
	//Элемент.СписокВыбора.Добавить(Ложь, "В рабочих днях");
	Элемент.Заголовок = "В рабочих днях";
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	//Элемент.РастягиватьПоГоризонтали = Истина;
	Элемент.ПутьКДанным = "Объект.Рин1_ДниКалендарные";
	Элемент.УстановитьДействие("ПриИзменении","Рин1_ДниКалендарныеПриИзменении");
	
	
	//Определяем доступность и видимость на форме.
	Элементы.СрокДоставки.Доступность = Объект.Рин1_ВозможнаРеализацияБезПереходаПраваСобственности;
	Элементы.СрокДоставки.Видимость = Объект.Рин1_ВозможнаРеализацияБезПереходаПраваСобственности;
	Элементы.ДниРабочие.Доступность = Объект.Рин1_ВозможнаРеализацияБезПереходаПраваСобственности;
	Элементы.ДниРабочие.Видимость = Объект.Рин1_ВозможнаРеализацияБезПереходаПраваСобственности;
//}}20200831 ГлазуновДВ
	
КонецПроцедуры

&НаСервере
Процедура Рин1_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ПодключитьДополнительныеЭлементыФормы();
	
	Если не Объект.ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем Тогда
		Элементы.ГруппаРеквизитыПечати.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Статус = Перечисления.СтатусыДоговоровКонтрагентов.НеСогласован;
		Объект.ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоЗаказамНакладным;
		
		// + [Rineco], [Киселев А.] [27.07.2021] 
		// Задача: [№ 12111], [# Установить флаг по умолчанию]
		Объект.ЗапрещаетсяПросроченнаяЗадолженность = Истина;
		// - [Rineco], [Киселев А.] [27.07.2021]
		
	КонецЕсли;
	
	//bercut задача 132п2
	Если не Рин1_ОбщийМодуль2.ЕстьПравоНаИзменениеДоговора() Тогда
		Если Объект.Статус = Перечисления.СтатусыДоговоровКонтрагентов.Действует Тогда
			//Элементы.ФормаГлобальныеКоманды.Доступность = Ложь;
			Элементы.ФормаЗаписатьИЗакрыть.Доступность = Ложь;
			Элементы.ФормаЗаписать.Доступность = Ложь;
			
			Элементы.СтраницаРасчетыИОформление.ТолькоПросмотр = Истина;
			Элементы.СтраницаПодтверждающиеДокументы.ТолькоПросмотр = Истина;
			Элементы.СтраницаУчетнаяИнформация.ТолькоПросмотр = Истина;
			Элементы.СтраницаДоставка.ТолькоПросмотр = Истина;
			Элементы.СтраницаКомментарий.ТолькоПросмотр = Истина;
			//
			Элементы.ГруппаШапкаЛево.ТолькоПросмотр = Истина;
			Элементы.ГруппаПериодДействия.ТолькоПросмотр = Истина;
			Элементы.УстановитьИнтервал.Доступность = Ложь;
			Элементы.ТипДоговора.ТолькоПросмотр = Истина;		
			Элементы.ГруппаОрганизация.ТолькоПросмотр = Истина;
			Элементы.Партнер.ТолькоПросмотр = Истина;
			Элементы.Контрагент.ТолькоПросмотр = Истина;
			Элементы.ИностранныйИсполнительВУтвержденномПеречнеГОЗ.ТолькоПросмотр = Истина;
			Элементы.ГруппаОплатаКредит.ТолькоПросмотр = Истина;
			Элементы.ЗачетОплаты.Доступность = Ложь;
		ИначеЕсли Объект.Статус = Перечисления.СтатусыДоговоровКонтрагентов.Закрыт Тогда
			ЭтаФорма.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ОснованиеЗаказКлиента Тогда
		Элементы.ТолькоНомерДата.Доступность = Истина; 
	Иначе 	
		Элементы.ТолькоНомерДата.Доступность = Ложь; 
	КонецЕсли;
	
	//
	Если Объект.Ссылка.Пустая() Тогда
		// + [Rineco], [Киселев А.Н.] [20.10.2021] 
		// Задача: [№ 19685], [#Не заполнять график оплаты]
		//Объект.ГрафикОплаты = Справочники.ГрафикиОплаты.НайтиПоНаименованию("Предоплата до отгрузки 100% (можно заказать без аванса)");		
		// - [Rineco], [Киселев А.Н.] [20.10.2021]
		
	//{{20200730 ГлазуновДВ Устанавливаем занчения по умолчанию для НДС
		Объект.СтавкаНДС = Перечисления.СтавкиНДС.НДС20;
		Объект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	//}}20200730 ГлазуновДВ
КонецЕсли;


	// + [Rineco], [Киселев А.Н.] [19.10.2021] 
	// Задача: [№ 20449], [#УстановкаПараметровДС]
	УстановитьПривилегированныйРежим(Истина);
	УстановитьВидимостьОбсуждений();
	УстановитьДоступностьСправочникаМероприятий();
	УстановитьДоступностьСтатуса();
	УстановитьПривилегированныйРежим(Ложь);
	// - [Rineco], [Киселев А.Н.] [19.10.2021]

	
КонецПроцедуры

&НаКлиенте
Процедура Рин1_СтатусПриИзмененииПеред(Элемент)
	//bercut задача 132п2
	СтатусДоговораВСсылке = ПолучитьСтатусДоговораВСсылке();
	
	Если не Рин1_ОбщийМодуль2.ЕстьПравоНаИзменениеДоговора() Тогда
		Если СтатусДоговораВСсылке = ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.НеСогласован") и Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.Действует") Тогда
			Сообщить("Отсутствует право на изменение статуса. Обратитесь к пользователю с полными правами!");
			Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.НеСогласован");
			Возврат;
		ИначеЕсли СтатусДоговораВСсылке = ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.Действует") Тогда
			Сообщить("Отсутствует право на изменение статуса. Обратитесь к пользователю с полными правами!");
			Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.Действует");
			Возврат;
		ИначеЕсли СтатусДоговораВСсылке = ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.ПустаяСсылка") Тогда 
			Сообщить("Отсутствует право на изменение статуса. Обратитесь к пользователю с полными правами!");
			Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.НеСогласован");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтатусДоговораВСсылке()
	//bercut задача 132п2
	Возврат Объект.Ссылка.Статус; 
	
КонецФункции // ОтсутствуетДоступКИзменению()

&НаСервере
Процедура Рин1_ПриЧтенииНаСервереПосле(ТекущийОбъект)
	
	//bercut задача 168
	Элементы.Основание.СписокВыбора.Очистить();
	//Элементы.Основание.СписокВыбора.Добавить(Объект.Наименование);
	Элементы.Основание.СписокВыбора.Добавить(Объект.НаименованиеДляПечати);
	Элементы.Основание.СписокВыбора.Добавить(Объект.НаименованиеДляПечати + " № " + Объект.Номер + " от " + Формат(Объект.Дата,"ДЛФ=DD"));
	Если не Объект.Основание = "" Тогда
		Элементы.Основание.СписокВыбора.Добавить(Объект.Основание);
	КонецЕсли;
	
	Элементы.ОснованиеНомер.СписокВыбора.Очистить();
	Элементы.ОснованиеНомер.СписокВыбора.Добавить(Объект.Номер);
		
	Элементы.ОснованиеДата.СписокВыбора.Очистить();
	Элементы.ОснованиеДата.СписокВыбора.Добавить(Объект.Дата);
	//
	
КонецПроцедуры

&НаКлиенте
Процедура Рин1_ОснованиеЗаказКлиентаПриИзмененииВместо(Элемент)
	
	Если Объект.ОснованиеЗаказКлиента Тогда
		//++Шерстюк Ю.Ю. 24.03.2021 задача 5465
		//Элементы.ТолькоНомерДата.Доступность = Истина; 
		Если Объект.Рин1_ПечатьОснованияКакВДиадок Тогда 
			Элементы.ТолькоНомерДата.Доступность = Ложь;
			Объект.ТолькоНомерДата = Истина;
		Иначе
			Элементы.ТолькоНомерДата.Доступность = Истина; 
		КонецЕсли;
		//--Шерстюк Ю.Ю.
	Иначе
		Объект.ТолькоНомерДата = Ложь; 
		Элементы.ТолькоНомерДата.Доступность = Ложь; 
	КонецЕсли;
	
КонецПроцедуры

//{{20200831 ГлазуновДВ (Задача № 2363)
&НаКлиенте
Процедура Рин1_ВозможнаРеализацияБезПереходаПраваСобственностиПриИзменении(Элемент)
	Элементы.СрокДоставки.Доступность = Объект.Рин1_ВозможнаРеализацияБезПереходаПраваСобственности;
	Элементы.СрокДоставки.Видимость = Объект.Рин1_ВозможнаРеализацияБезПереходаПраваСобственности;
	Элементы.ДниРабочие.Доступность = Объект.Рин1_ВозможнаРеализацияБезПереходаПраваСобственности;
	Элементы.ДниРабочие.Видимость = Объект.Рин1_ВозможнаРеализацияБезПереходаПраваСобственности;
	
    Рин1_ВозможнаРеализацияБезПереходаПраваСобственностиПриИзмененииСервер();
КонецПроцедуры

&НаСервере
Функция Рин1_ВозможнаРеализацияБезПереходаПраваСобственностиПриИзмененииСервер()

КонецФункции

&НаКлиенте
Процедура Рин1_ДниКалендарныеПриИзменении(Элемент)
	//Если Объект.Рин1_ДниКалендарные Тогда
	//	Элемент.Заголовок = "В рабочих днях";
	//Иначе
	//	Элемент.Заголовок = "В календарных днях";
	//КонецЕсли;
КонецПроцедуры

//}}20200831 ГлазуновДВ
&НаКлиенте
Процедура Рин1_Рин1_ПечатьОснованияКакВДиадокПриИзмененииПосле(Элемент)
	//++Шерстюк Ю.Ю. 24.03.2021 задача 5465
	Если Не Объект.Рин1_ПечатьОснованияКакВДиадок и Объект.ОснованиеЗаказКлиента Тогда 
       Элементы.ТолькоНомерДата.Доступность = Истина; 
   КонецЕсли;
   //++Шерстюк Ю.Ю.
КонецПроцедуры

// + [Rineco], [Киселев А.Н.] [19.10.2021] 
// Задача: [№ 20449], [#Отправка сообщения]
&НаКлиенте
Процедура Рин1_РИНЭКО_ОтправитьСообщениеПосле(Команда)
	
	Если Параметры.Ключ.Пустая() Тогда
		Сообщить("Необходимо записать объект !");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РИНЭКО_Сообщение) Тогда
		Сообщить("Введите сообщение !");
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.РИНЭКО_ПланМероприятий) И Не ЗначениеЗаполнено(Объект.РИНЭКО_ДатаВыполненияПлана) Тогда 
		
		ОбщегоНазначенияКлиент.СообщитьПользователю("Необходимо заполнить дату выполнения плана",Объект.Ссылка,"Объект.РИНЭКО_ДатаВыполненияПлана");
		Возврат;
	КонецЕсли;
	
	Рин1_РИНЭКО_ОтправитьСообщениеПослеНаСервере();
	
	ПоказатьОповещениеПользователя("Сообщение успешно отправлено");
	
	РИНЭКО_Сообщение = "";
	ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	
	
КонецПроцедуры


// + [Rineco], [Киселев А.Н.] [19.10.2021] 
// Задача: [№ 20449], [#Отправка сообщения]
&НаСервере
Процедура Рин1_РИНЭКО_ОтправитьСообщениеПослеНаСервере()
	
	СообщениеДляОтправки = "";
	
	Если ЗначениеЗаполнено(Объект.РИНЭКО_ПланМероприятий) Тогда
		СообщениеДляОтправки = Строка(Формат(Объект.РИНЭКО_ДатаВыполненияПлана,"ДФ=dd.MM.yyyy")) + " " + Объект.РИНЭКО_ПланМероприятий + Символы.ПС + РИНЭКО_Сообщение;
	Иначе 
		СообщениеДляОтправки = РИНЭКО_Сообщение; 	
	КонецЕсли;
	
	РегистрыСведений.РИНЭКО_ИсторияОбсуждений.ДобавитьНовуюЗапись(Пользователи.ТекущийПользователь(),Объект.Ссылка,СообщениеДляОтправки,ЗначениеЗаполнено(Объект.РИНЭКО_ПланМероприятий));
	
КонецПроцедуры


// + [Rineco], [Киселев А.Н.] [19.10.2021] 
// Задача: [№ 20449], [#Видимость обсуждений]
&НаСервере
Процедура УстановитьДоступностьСправочникаМероприятий()
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ГруппаПланМероприятий","Видимость",УправлениеДоступом.ЕстьРоль("РИНЭКО_ЧтениеСправочникаРИНЭКО_ПланМероприятийПоРаботеСЗД",Объект.Ссылка,Пользователи.ТекущийПользователь()));	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"РИНЭКО_ПланМероприятий","ТолькоПросмотр",НЕ УправлениеДоступом.ЕстьРоль("РИНЭКО_ДобавлениеИзменениеСправочникаРИНЭКО_ПланМероприятийПоРаботеСЗД",Объект.Ссылка,Пользователи.ТекущийПользователь()));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"РИНЭКО_ДатаВыполненияПлана","ТолькоПросмотр",НЕ УправлениеДоступом.ЕстьРоль("РИНЭКО_ДобавлениеИзменениеСправочникаРИНЭКО_ПланМероприятийПоРаботеСЗД",Объект.Ссылка,Пользователи.ТекущийПользователь()));
КонецПроцедуры

// + [Rineco], [Киселев А.Н.] [19.10.2021] 
// Задача: [№ 20449], [#Видимость обсуждений]
&НаСервере
Процедура УстановитьДоступностьСтатуса()
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"РИНЭКО_СтатусДЗ","ТолькоПросмотр",НЕ УправлениеДоступом.ЕстьРоль("РИНЭКО_УстановкаСтатусаВДоговореКонтрагента",Объект.Ссылка,Пользователи.ТекущийПользователь()));
КонецПроцедуры

// + [Rineco], [Киселев А.Н.] [19.10.2021] 
// Задача: [№ 20449], [#Видимость обсуждений]
&НаСервере
Процедура УстановитьВидимостьОбсуждений()
	
	Если Не Параметры.Ключ.Пустая() И Объект.ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(РИНЭКО_Обсуждения,"Договор",Объект.Ссылка);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ГруппаОбсуждения","Видимость",Истина);
	Иначе 
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ГруппаОбсуждения","Видимость",Ложь);
	КонецЕсли;
	
КонецПроцедуры

// + [Rineco], [Киселев А.Н.] [19.10.2021] 
// Задача: [№ 20449], [#Видимость обсуждений]
&НаКлиенте
Процедура Рин1_ТипДоговораПриИзмененииПосле(Элемент)
	УстановитьВидимостьОбсуждений();
КонецПроцедуры

// + [Rineco], [Киселев А.Н.] [19.10.2021] 
// Задача: [№ 20449], [#Видимость обсуждений]
&НаСервере
Процедура Рин1_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	УстановитьВидимостьОбсуждений();
КонецПроцедуры

// + [Rineco], [Киселев А.Н.] [19.10.2021] 
// Задача: [№ 20449], [#Фильтр выбора статусов]
&НаКлиенте
Процедура Рин1_РИНЭКО_СтатусДЗОбработкаВыбораПосле(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
		
	Если ВыбранноеЗначение = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Перечисление.СтатусДЗ.Добросовестная") ИЛИ ВыбранноеЗначение = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Перечисление.СтатусДЗ.Недобросовестная") ИЛИ ВыбранноеЗначение = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Перечисление.СтатусДЗ.Проблемная") Тогда
		
		Если Параметры.Ключ.Пустая() Тогда
			ВыбранноеЗначение = ""
		Иначе
			ВыбранноеЗначение = Объект.РИНЭКО_СтатусДЗ;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// + [Rineco], [Киселев А.Н.] [19.10.2021] 
// Задача: [№ 20449], [#ИсторияСтатусов]
&НаКлиенте
Процедура Рин1_РИНЭКО_ИсторияСтатусовПосле(Команда)
	Если Не Параметры.Ключ.Пустая() Тогда
		ПараметрыФормы = Новый Структура("Договор", Объект.Ссылка);
		ОткрытьФорму("РегистрСведений.РИНЭКО_ИсторияИзмененияСтатуса.ФормаСписка", ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры
