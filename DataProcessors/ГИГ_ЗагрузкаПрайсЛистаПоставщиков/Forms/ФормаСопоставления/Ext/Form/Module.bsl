﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	 КопироватьДанныеФормы(ВладелецФормы.Объект, Объект);
	 пСообщение = СопоставитьНоменклатуруНаСервере(Объект.Производитель);
	 //ЭлементыДерева = ТаблицаСопоставления.ПолучитьЭлементы();
	 Сообщить(пСообщение);
 КонецПроцедуры
 
 
 &НаСервере
Процедура УстановитьУсловноеОформление() //не работает
	Категория = Неопределено;
	ЕстьОформление = Ложь;
	ЭлУсловногоОформления = Неопределено;
	//стрТЗУсловноеОформление = УсловноеОформление.Добавить();
	//стрТЗУсловноеОформление.ПолеНоменклатура = Категория;
	//
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	//стрТЗУсловноеОформление.Идентификатор = УсловноеОформление.ПолучитьИдентификаторПоОбъекту(ЭлементОформления);
		
	//Список отбора
	ДЗ = РеквизитФормыВЗначение("ТаблицаСопоставления");
	стрКатегория = ДЗ.Строки.Найти(Категория, "ПолеНоменклатура", Истина);
	СписокОтб = Новый СписокЗначений;
	//ДобавитьДочерниеКатегории(стрКатегория, СписокОтб, Категория);
		
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаСопоставления.ПолеНоменклатура");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ПравоеЗначение = СписокОтб;
	ЭлементОтбора.Использование = Истина;
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.Бирюзовый);


КонецПроцедуры

 
 &НаСервере
 Функция ЗаполнитьТаблицуСравнения(тз)
	 
КонецФункции
 
&НаСервере 
Функция НайтиРазличия(пПроизводитель)
	
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	Номенклатура.Наименование КАК НаименованиеНоменклатура,
		                      |	Номенклатура.Артикул КАК АртикулНоменклатура,
		                      |	ЕСТЬNULL(Номенклатура.ВесЕдиницаИзмерения, 0) КАК ВесЕдИзмеренияНоменклатура,
		                      |	Номенклатура.НаименованиеПолное КАК НаименованиеПолноеНоменклатура,
		                      |	Номенклатура.СтавкаНДС КАК СтавкаНДСНоменклатура,
		                      |	Номенклатура.ОбъемЕдиницаИзмерения КАК ОбъемЕдИзмНоменклатура,
		                      |	Номенклатура.ЦеноваяГруппа КАК ЦеноваяГруппаНоменклатура,
		                      |	Номенклатура.Ссылка КАК Ссылка,
		                      |	Номенклатура.Производитель КАК Производитель,
		                      |	Номенклатура.ИспользоватьУпаковки КАК ИспользоватьУпаковкиНоменклатура,
		                      |	Номенклатура.ЕдиницаИзмерения КАК БазоваяЕдИзмНоменклатура,
		                      |	ЕСТЬNULL(Номенклатура.ВесЧислитель, 0) КАК ВесНоменклатура,
		                      |	ЕСТЬNULL(Номенклатура.ОбъемЧислитель, 0) КАК ОбъемНоменклатура,
		                      |	Номенклатура.ВесЕдиницаИзмерения КАК ВесЕдиницаИзмерения,
		                      |	Номенклатура.ОбъемЕдиницаИзмерения КАК ОбъемЕдиницаИзмерения
		                      |ПОМЕСТИТЬ СпрНоменклатура
		                      |ИЗ
		                      |	Справочник.Номенклатура КАК Номенклатура
		                      |ГДЕ
		                      |	Номенклатура.Производитель = &Производитель
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ
		                      |	СпрНоменклатура.Ссылка КАК Номенклатура,
		                      |	ГИГ_НоменклатураПроизводителей.Ссылка КАК НоменклатураПроизводителей,
		                      |	ВЫБОР
		                      |		КОГДА СпрНоменклатура.Ссылка <> ГИГ_НоменклатураПроизводителей.Номенклатура
		                      |			ТОГДА ИСТИНА
		                      |		ИНАЧЕ ЛОЖЬ
		                      |	КОНЕЦ КАК СоответствиеНоменклатуры,
		                      |	ВЫБОР
		                      |		КОГДА ГИГ_НоменклатураПроизводителей.Наименование <> СпрНоменклатура.НаименованиеНоменклатура
		                      |			ТОГДА ИСТИНА
		                      |		ИНАЧЕ ЛОЖЬ
		                      |	КОНЕЦ КАК Наименование,
		                      |	ВЫБОР
		                      |		КОГДА СпрНоменклатура.НаименованиеПолноеНоменклатура <> ГИГ_НоменклатураПроизводителей.НаименованиеПолное
		                      |			ТОГДА ИСТИНА
		                      |		ИНАЧЕ ЛОЖЬ
		                      |	КОНЕЦ КАК НаименованиеПолное,
		                      |	ВЫБОР
		                      |		КОГДА ГИГ_НоменклатураПроизводителей.ЦеноваяКатегория <> СпрНоменклатура.ЦеноваяГруппаНоменклатура
		                      |			ТОГДА ИСТИНА
		                      |		ИНАЧЕ ЛОЖЬ
		                      |	КОНЕЦ КАК ЦеноваяГруппа,
		                      |	ВЫБОР
		                      |		КОГДА СпрНоменклатура.БазоваяЕдИзмНоменклатура <> ГИГ_НоменклатураПроизводителей.БазоваяЕдиницаИзмерения
		                      |			ТОГДА ИСТИНА
		                      |		ИНАЧЕ ЛОЖЬ
		                      |	КОНЕЦ КАК БазоваяЕдИзм,
		                      |	ВЫБОР
		                      |		КОГДА СпрНоменклатура.ОбъемЕдИзмНоменклатура <> ГИГ_НоменклатураПроизводителей.ЕИОбъема
		                      |			ТОГДА ИСТИНА
		                      |		ИНАЧЕ ЛОЖЬ
		                      |	КОНЕЦ КАК ОбъемЕдИзм,
		                      |	ВЫБОР
		                      |		КОГДА СпрНоменклатура.ОбъемНоменклатура <> ГИГ_НоменклатураПроизводителей.ОбъемБазовой
		                      |			ТОГДА ИСТИНА
		                      |		ИНАЧЕ ЛОЖЬ
		                      |	КОНЕЦ КАК Объем,
		                      |	ВЫБОР
		                      |		КОГДА СпрНоменклатура.ВесНоменклатура <> ГИГ_НоменклатураПроизводителей.ВесБазовой
		                      |			ТОГДА ИСТИНА
		                      |		ИНАЧЕ ЛОЖЬ
		                      |	КОНЕЦ КАК Вес,
		                      |	ВЫБОР
		                      |		КОГДА СпрНоменклатура.ВесЕдиницаИзмерения <> ГИГ_НоменклатураПроизводителей.ЕИВеса
		                      |			ТОГДА ИСТИНА
		                      |		ИНАЧЕ ЛОЖЬ
		                      |	КОНЕЦ КАК ВесЕдИзм,
		                      |	ГИГ_НоменклатураПроизводителей.ОсновнаяЕдиницаИзмерения КАК ОсновнаяЕдиницаИзмерения,
		                      |	ГИГ_НоменклатураПроизводителей.КоэффициентОсновнойЕдИзм КАК КоэффициентОсновнойЕдИзм
		                      |ПОМЕСТИТЬ ТаблицаСравнения
		                      |ИЗ
		                      |	Справочник.ГИГ_НоменклатураПроизводителей КАК ГИГ_НоменклатураПроизводителей
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СпрНоменклатура КАК СпрНоменклатура
		                      |		ПО (СпрНоменклатура.Производитель = ГИГ_НоменклатураПроизводителей.Производитель)
		                      |			И (ГИГ_НоменклатураПроизводителей.Артикул ПОДОБНО СпрНоменклатура.АртикулНоменклатура
		                      |				ИЛИ СпрНоменклатура.Ссылка = ГИГ_НоменклатураПроизводителей.Номенклатура)
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ
		                      |	ТаблицаСравнения.Номенклатура КАК Номенклатура,
		                      |	ТаблицаСравнения.НоменклатураПроизводителей КАК НоменклатураПроизводителей,
		                      |	ТаблицаСравнения.СоответствиеНоменклатуры КАК СоответствиеНоменклатуры,
		                      |	ТаблицаСравнения.Наименование КАК Наименование,
		                      |	ТаблицаСравнения.НаименованиеПолное КАК НаименованиеПолное,
		                      |	ТаблицаСравнения.ЦеноваяГруппа КАК ЦеноваяГруппа,
		                      |	ТаблицаСравнения.БазоваяЕдИзм КАК БазоваяЕдИзм,
		                      |	ТаблицаСравнения.ОбъемЕдИзм КАК ОбъемЕдИзм,
		                      |	ТаблицаСравнения.Объем КАК Объем,
		                      |	ТаблицаСравнения.Вес КАК Вес,
		                      |	ТаблицаСравнения.ВесЕдИзм КАК ВесЕдИзм,
		                      |	УпаковкиЕдиницыИзмерения.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		                      |	МИНИМУМ(УпаковкиЕдиницыИзмерения.Числитель) КАК Числитель,
		                      |	ТаблицаСравнения.ОсновнаяЕдиницаИзмерения КАК ОсновнаяЕдиницаИзмерения,
		                      |	ТаблицаСравнения.КоэффициентОсновнойЕдИзм КАК КоэффициентОсновнойЕдИзм,
		// !!! ТУТ идет выбор УПАКОВОК				  
		                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
		                      |			КОГДА ТаблицаСравнения.ОсновнаяЕдиницаИзмерения = &ПустаяЕдиницаИзмерения
		                      |				ТОГДА ЛОЖЬ
		                      |			КОГДА УпаковкиЕдиницыИзмерения.ЕдиницаИзмерения = ТаблицаСравнения.ОсновнаяЕдиницаИзмерения
		                      |					И УпаковкиЕдиницыИзмерения.Числитель = ТаблицаСравнения.КоэффициентОсновнойЕдИзм
		                      |				ТОГДА ЛОЖЬ
		                      |			ИНАЧЕ ИСТИНА
		                      |		КОНЕЦ) КАК ИндивидуальныйНабор
		                      |ПОМЕСТИТЬ НоменклатураПоПолямСопоставления
		                      |ИЗ
		                      |	ТаблицаСравнения КАК ТаблицаСравнения
		                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
		                      |		ПО ТаблицаСравнения.Номенклатура = УпаковкиЕдиницыИзмерения.Владелец
		                      |
		                      |СГРУППИРОВАТЬ ПО
		                      |	ТаблицаСравнения.Номенклатура,
		                      |	ТаблицаСравнения.НоменклатураПроизводителей,
		                      |	ТаблицаСравнения.СоответствиеНоменклатуры,
		                      |	ТаблицаСравнения.ОсновнаяЕдиницаИзмерения,
		                      |	ТаблицаСравнения.Объем,
		                      |	ТаблицаСравнения.НаименованиеПолное,
		                      |	ТаблицаСравнения.ОбъемЕдИзм,
		                      |	ТаблицаСравнения.Вес,
		                      |	ТаблицаСравнения.БазоваяЕдИзм,
		                      |	ТаблицаСравнения.Наименование,
		                      |	УпаковкиЕдиницыИзмерения.ЕдиницаИзмерения,
		                      |	ТаблицаСравнения.ЦеноваяГруппа,
		                      |	ТаблицаСравнения.ВесЕдИзм,
		                      |	ТаблицаСравнения.КоэффициентОсновнойЕдИзм
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ
		                      |	НоменклатураПоПолямСопоставления.Номенклатура КАК Номенклатура,
		                      |	НоменклатураПоПолямСопоставления.НоменклатураПроизводителей КАК НоменклатураПроизводителей,
		                      |	НоменклатураПоПолямСопоставления.СоответствиеНоменклатуры КАК СоответствиеНоменклатуры,
		                      |	НоменклатураПоПолямСопоставления.Наименование КАК Наименование,
		                      |	НоменклатураПоПолямСопоставления.НаименованиеПолное КАК НаименованиеПолное,
		                      |	НоменклатураПоПолямСопоставления.ЦеноваяГруппа КАК ЦеноваяГруппа,
		                      |	НоменклатураПоПолямСопоставления.БазоваяЕдИзм КАК БазоваяЕдИзм,
		                      |	НоменклатураПоПолямСопоставления.ОбъемЕдИзм КАК ОбъемЕдИзм,
		                      |	НоменклатураПоПолямСопоставления.Объем КАК Объем,
		                      |	НоменклатураПоПолямСопоставления.Вес КАК Вес,
		                      |	НоменклатураПоПолямСопоставления.ВесЕдИзм КАК ВесЕдИзм,
		                      |	НоменклатураПоПолямСопоставления.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		                      |	НоменклатураПоПолямСопоставления.Числитель КАК Числитель,
		                      |	НоменклатураПоПолямСопоставления.ОсновнаяЕдиницаИзмерения КАК ОсновнаяЕдиницаИзмерения,
		                      |	НоменклатураПоПолямСопоставления.КоэффициентОсновнойЕдИзм КАК КоэффициентОсновнойЕдИзм,
		                      |	НоменклатураПоПолямСопоставления.ИндивидуальныйНабор КАК ИндивидуальныйНабор
		                      |ИЗ
		                      |	НоменклатураПоПолямСопоставления КАК НоменклатураПоПолямСопоставления
		                      |ГДЕ
		                      |	(НоменклатураПоПолямСопоставления.СоответствиеНоменклатуры = ИСТИНА
		                      |			ИЛИ НоменклатураПоПолямСопоставления.НаименованиеПолное = ИСТИНА
		                      |			ИЛИ НоменклатураПоПолямСопоставления.ЦеноваяГруппа = ИСТИНА
		                      |			ИЛИ НоменклатураПоПолямСопоставления.БазоваяЕдИзм = ИСТИНА
		                      |			ИЛИ НоменклатураПоПолямСопоставления.ОбъемЕдИзм = ИСТИНА
		                      |			ИЛИ НоменклатураПоПолямСопоставления.Объем = ИСТИНА
		                      |			ИЛИ НоменклатураПоПолямСопоставления.Вес = ИСТИНА
		                      |			ИЛИ НоменклатураПоПолямСопоставления.ВесЕдИзм = ИСТИНА
		                      |			ИЛИ НоменклатураПоПолямСопоставления.ИндивидуальныйНабор = ИСТИНА)
		                      |
		                      |СГРУППИРОВАТЬ ПО
		                      |	НоменклатураПоПолямСопоставления.ОсновнаяЕдиницаИзмерения,
		                      |	НоменклатураПоПолямСопоставления.ИндивидуальныйНабор,
		                      |	НоменклатураПоПолямСопоставления.ОбъемЕдИзм,
		                      |	НоменклатураПоПолямСопоставления.НоменклатураПроизводителей,
		                      |	НоменклатураПоПолямСопоставления.Наименование,
		                      |	НоменклатураПоПолямСопоставления.ВесЕдИзм,
		                      |	НоменклатураПоПолямСопоставления.Номенклатура,
		                      |	НоменклатураПоПолямСопоставления.БазоваяЕдИзм,
		                      |	НоменклатураПоПолямСопоставления.ЦеноваяГруппа,
		                      |	НоменклатураПоПолямСопоставления.СоответствиеНоменклатуры,
		                      |	НоменклатураПоПолямСопоставления.НаименованиеПолное,
		                      |	НоменклатураПоПолямСопоставления.Вес,
		                      |	НоменклатураПоПолямСопоставления.Объем,
		                      |	НоменклатураПоПолямСопоставления.ЕдиницаИзмерения,
		                      |	НоменклатураПоПолямСопоставления.Числитель,
		                      |	НоменклатураПоПолямСопоставления.КоэффициентОсновнойЕдИзм
		                      |ИТОГИ
		                      |	МАКСИМУМ(НоменклатураПроизводителей),
		                      |	МАКСИМУМ(СоответствиеНоменклатуры),
		                      |	МАКСИМУМ(Наименование),
		                      |	МАКСИМУМ(НаименованиеПолное),
		                      |	МАКСИМУМ(ЦеноваяГруппа),
		                      |	МАКСИМУМ(БазоваяЕдИзм),
		                      |	МАКСИМУМ(ОбъемЕдИзм),
		                      |	МАКСИМУМ(Объем),
		                      |	МАКСИМУМ(Вес),
		                      |	МАКСИМУМ(ВесЕдИзм),
		                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЕдиницаИзмерения),
		                      |	МАКСИМУМ(Числитель),
		                      |	МАКСИМУМ(ОсновнаяЕдиницаИзмерения),
		                      |	МАКСИМУМ(КоэффициентОсновнойЕдИзм),
		                      |	МИНИМУМ(ИндивидуальныйНабор)
		                      |ПО
		                      |	Номенклатура");
	
		пЕдИзмеренияПусто = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
		Запрос.УстановитьПараметр("Производитель",пПроизводитель);
		Запрос.УстановитьПараметр("ПустаяЕдиницаИзмерения",пЕдИзмеренияПусто);
		Запрос.УстановитьПараметр("Артикул","0000216888");

		ИтоговаяВыборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Возврат ИтоговаяВыборка;

	
КонецФункции

&НаСервере
Функция СопоставитьНоменклатуруНаСервере(пПроизводитель)
    пСообщениеОбИзменениях = "";
	тзДляИсправления = Новый ДеревоЗначений;// ТаблицаЗначений;
	тзДляИсправления.Колонки.Добавить("Пометка");
	тзДляИсправления.Колонки.Добавить("Номенклатура");
	тзДляИсправления.Колонки.Добавить("НоменклатураПроизводителя");
	тзДляИсправления.Колонки.Добавить("ПолеНоменклатура");
	тзДляИсправления.Колонки.Добавить("ПолеНоменклатураПроизводителя");
	тзДляИсправления.Колонки.Добавить("Отличие");
	тзДляИсправления.Колонки.Добавить("Описание");

	ИтоговаяВыборка = НайтиРазличия(пПроизводитель);
	
	
	пЕдИзмВеса = Справочники.УпаковкиЕдиницыИзмерения.НайтиПоКоду("166");//кг
	пЕдИзмМетр = Справочники.УпаковкиЕдиницыИзмерения.НайтиПоКоду("006");//м
	пЕдИзмОбъем = Справочники.УпаковкиЕдиницыИзмерения.НайтиПоКоду("113"); //м3

	Пока ИтоговаяВыборка.Следующий() Цикл
		
		Если ((ИтоговаяВыборка.Наименование или  ИтоговаяВыборка.Вес) и ИтоговаяВыборка.БазоваяЕдИзм) 
			или ИтоговаяВыборка.ВесЕдИзм или ИтоговаяВыборка.НаименованиеПолное или  ИтоговаяВыборка.БазоваяЕдИзм 
			или ((ИтоговаяВыборка.Объем или ИтоговаяВыборка.ОбъемЕдИзм) и ИтоговаяВыборка.БазоваяЕдИзм ) Тогда
			
			пстрРодитель = тзДляИсправления.Строки.Добавить();
			пстрРодитель.Номенклатура = ИтоговаяВыборка.Номенклатура;
		КонецЕсли;
			
//Исходное		Если ИтоговаяВыборка.ИндивидуальныйНабор = Истина и ИтоговаяВыборка.КоэффициентОсновнойЕдИзм > 1 и ИтоговаяВыборка.БазоваяЕдИзм = Ложь Тогда
		Если ИтоговаяВыборка.ИндивидуальныйНабор = Истина и ИтоговаяВыборка.КоэффициентОсновнойЕдИзм > 1 Тогда
	//{{20200616-20200715 ГлазуновДВ Вставили проверку по существованию УПАКОВОК!!!
							//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
			// Данный фрагмент построен конструктором.
			// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	УпаковкиЕдиницыИзмерения.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
				|ГДЕ
				|	УпаковкиЕдиницыИзмерения.Владелец = &Владелец
				|	И УпаковкиЕдиницыИзмерения.ЕдиницаИзмерения = &ЕдиницаИзмерения
				|	И УпаковкиЕдиницыИзмерения.Числитель = &Числитель
				|	И УпаковкиЕдиницыИзмерения.Знаменатель = &Знаменатель";
			
			Запрос.УстановитьПараметр("Владелец", ИтоговаяВыборка.Номенклатура);
			Запрос.УстановитьПараметр("ЕдиницаИзмерения", ИтоговаяВыборка.ОсновнаяЕдиницаИзмерения);
			Запрос.УстановитьПараметр("Числитель", ИтоговаяВыборка.КоэффициентОсновнойЕдИзм);
			Запрос.УстановитьПараметр("Знаменатель", 1);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				// Вставить обработку выборки ВыборкаДетальныеЗаписи
			КонецЦикла;
			
			Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
				
				//пУпаковкиОбъект = Справочники.УпаковкиЕдиницыИзмерения.СоздатьЭлемент();
				//пУпаковкиОбъект.Владелец = ИтоговаяВыборка.Номенклатура;
				//пУпаковкиОбъект.ЕдиницаИзмерения = ИтоговаяВыборка.ОсновнаяЕдиницаИзмерения;
				//пУпаковкиОбъект.Числитель = ИтоговаяВыборка.КоэффициентОсновнойЕдИзм;
				//пУпаковкиОбъект.Знаменатель = 1;
				//пУпаковкиОбъект.Наименование = "упак (" + ИтоговаяВыборка.КоэффициентОсновнойЕдИзм + " " + ИтоговаяВыборка.Номенклатура.ЕдиницаИзмерения + ")";
				//пУпаковкиОбъект.Безразмерная = Ложь;
				//пУпаковкиОбъект.ВесЕдиницаИзмерения = пЕдИзмВеса;
				//пУпаковкиОбъект.ГлубинаЕдиницаИзмерения = пЕдИзмМетр;
				//пУпаковкиОбъект.ШиринаЕдиницаИзмерения = пЕдИзмМетр;
				//пУпаковкиОбъект.ОбъемЕдиницаИзмерения = пЕдИзмОбъем;
				//пУпаковкиОбъект.ВысотаЕдиницаИзмерения = пЕдИзмМетр;
				//пУпаковкиОбъект.ПоставляетсяВМногооборотнойТаре = Ложь;
				//пУпаковкиОбъект.ТипИзмеряемойВеличины =  Перечисления.ТипыИзмеряемыхВеличин.Упаковка;
				//пУпаковкиОбъект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Конечная;
				//пУпаковкиОбъект.НаименованиеПолное = пУпаковкиОбъект.Наименование;			
				//Попытка
				//	пУпаковкиОбъект.Записать();
				//Исключение
				//КонецПопытки;
				//
				//пОбъектНоменклатура = ИтоговаяВыборка.Номенклатура.ПолучитьОбъект();
				//Если Не ИтоговаяВыборка.Номенклатура.ИспользоватьУпаковки Тогда
				//	пОбъектНоменклатура.ИспользоватьУпаковки = Истина;
				//КонецЕсли;
				//Попытка
				//	пОбъектНоменклатура.Записать();
				//Исключение
				//КонецПопытки;
				//
				//пСообщениеОбИзменениях = пСообщениеОбИзменениях + "Номенклатура " + ИтоговаяВыборка.Номенклатура.Наименование + " добавлен Индивидуальный набор " +  пУпаковкиОбъект.Наименование + Символы.ПС;
		
			//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
			
		//ГлазуновДВ Добавлена возможность отследить изменение УПАКОВКИ	
				пНоваяСтрока = пстрРодитель.Строки.Добавить();
				пНоваяСтрока.Номенклатура = ИтоговаяВыборка.Номенклатура;
				пНоваяСтрока.ПолеНоменклатура = "Упаковка";
				пНоваяСтрока.НоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей;
				пНоваяСтрока.ПолеНоменклатураПроизводителя = "" + ИтоговаяВыборка.ОсновнаяЕдиницаИзмерения + ", " + ИтоговаяВыборка.КоэффициентОсновнойЕдИзм;
	 			пНоваяСтрока.Отличие = "ЕдиницаИзмеренияУпаковки";
				пНоваяСтрока.Описание = "Изменена Единица измерения упаковки";
			
			КонецЕсли;
	//}}20200616-20200715 ГлазуновДВ 
		КонецЕсли;

		Если ИтоговаяВыборка.СоответствиеНоменклатуры и ИтоговаяВыборка.Номенклатура <> ИтоговаяВыборка.НоменклатураПроизводителей.Номенклатура Тогда
			пНоменклатураПроизводителяОбъект = ИтоговаяВыборка.НоменклатураПроизводителей.ПолучитьОбъект();
			пНоменклатураПроизводителяОбъект.Номенклатура = ИтоговаяВыборка.Номенклатура;
			пНоменклатураПроизводителяОбъект.Записать();
			пСообщениеОбИзменениях = пСообщениеОбИзменениях + "Номенклатура " + ИтоговаяВыборка.Номенклатура.Наименование + " установлено соответствие справочника Номенклатура производителя" + Символы.ПС;
		КонецЕсли;
			
		Если ИтоговаяВыборка.ЦеноваяГруппа 	Тогда 
			пНоменклатураОбъект = ИтоговаяВыборка.Номенклатура.ПолучитьОбъект();
			пНоменклатураОбъект.ЦеноваяГруппа = ИтоговаяВыборка.НоменклатураПроизводителей.ЦеноваяКатегория;
			пНоменклатураОбъект.Записать();
			
			пСообщениеОбИзменениях = пСообщениеОбИзменениях + "Номенклатура " + ИтоговаяВыборка.Номенклатура.Наименование + " изменена ценовая группа" + Символы.ПС;

		КонецЕсли;
		
		Если (ИтоговаяВыборка.Вес или ИтоговаяВыборка.ВесЕдИзм) и  ИтоговаяВыборка.БазоваяЕдИзм = Ложь Тогда
			пНоменклатураОбъект = ИтоговаяВыборка.Номенклатура.ПолучитьОбъект();
			пНоменклатураОбъект.ВесЕдиницаИзмерения = ИтоговаяВыборка.НоменклатураПроизводителей.ЕИВеса;
			пНоменклатураОбъект.ВесЧислитель = ИтоговаяВыборка.НоменклатураПроизводителей.ВесБазовой;
			пНоменклатураОбъект.ВесЗнаменатель = 1;
			пНоменклатураОбъект.ВесИспользовать = Истина;
			пНоменклатураОбъект.Записать();	
			пСообщениеОбИзменениях = пСообщениеОбИзменениях + "Номенклатура " + ИтоговаяВыборка.Номенклатура.Наименование + " изменен вес базовой ед.изм." + Символы.ПС;

		КонецЕсли;
		
		Если (ИтоговаяВыборка.Объем или ИтоговаяВыборка.ОбъемЕдИзм) и  ИтоговаяВыборка.БазоваяЕдИзм = Ложь Тогда
			пНоменклатураОбъект = ИтоговаяВыборка.Номенклатура.ПолучитьОбъект();
			пНоменклатураОбъект.ОбъемЕдиницаИзмерения = ИтоговаяВыборка.НоменклатураПроизводителей.ЕИОбъема;
			пНоменклатураОбъект.ОбъемЧислитель = ИтоговаяВыборка.НоменклатураПроизводителей.ОбъемБазовой;
			пНоменклатураОбъект.ОбъемЗнаменатель = 1;
			пНоменклатураОбъект.ОбъемИспользовать = Истина;
			пНоменклатураОбъект.Записать();
			пСообщениеОбИзменениях = пСообщениеОбИзменениях + "Номенклатура " + ИтоговаяВыборка.Номенклатура.Наименование + " изменен объем базовой ед.изм." + Символы.ПС;

		КонецЕсли;

		Если ИтоговаяВыборка.Наименование Тогда
			пНоваяСтрока = пстрРодитель.Строки.Добавить();
			пНоваяСтрока.Номенклатура = ИтоговаяВыборка.Номенклатура;
			пНоваяСтрока.НоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей;
			пНоваяСтрока.ПолеНоменклатура = ИтоговаяВыборка.Номенклатура.Наименование;
			пНоваяСтрока.ПолеНоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей.Наименование;
 			пНоваяСтрока.Отличие = "Наименование";
			пНоваяСтрока.Описание = "Отличается Наименование";
		КонецЕсли;
		
		Если ИтоговаяВыборка.НаименованиеПолное Тогда
			пНоваяСтрока = пстрРодитель.Строки.Добавить();
			пНоваяСтрока.Номенклатура = ИтоговаяВыборка.Номенклатура;
			пНоваяСтрока.НоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей;
			пНоваяСтрока.ПолеНоменклатура = ИтоговаяВыборка.Номенклатура.НаименованиеПолное;
			пНоваяСтрока.ПолеНоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей.НаименованиеПолное;
 			пНоваяСтрока.Отличие = "НаименованиеПолное";
			пНоваяСтрока.Описание = "Отличается Наименование полное";
		КонецЕсли;
		
		Если ИтоговаяВыборка.БазоваяЕдИзм Тогда
			пНоваяСтрока = пстрРодитель.Строки.Добавить();
			пНоваяСтрока.Номенклатура = ИтоговаяВыборка.Номенклатура;
			пНоваяСтрока.НоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей;
			пНоваяСтрока.ПолеНоменклатура = ИтоговаяВыборка.Номенклатура.ЕдиницаИзмерения;
			пНоваяСтрока.ПолеНоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей.БазоваяЕдиницаИзмерения;
 			пНоваяСтрока.Отличие = "ЕдиницаИзмерения";
			пНоваяСтрока.Описание = "Изменена Базовая единица измерения";
			 
			Если ИтоговаяВыборка.Вес или ИтоговаяВыборка.ВесЕдИзм Тогда
				пНоваяСтрока = пстрРодитель.Строки.Добавить();
				пНоваяСтрока.Номенклатура = ИтоговаяВыборка.Номенклатура;
				пНоваяСтрока.НоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей;
				пНоваяСтрока.ПолеНоменклатура = ИтоговаяВыборка.Номенклатура.ВесЧислитель;
				пНоваяСтрока.ПолеНоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей.ВесБазовой;
 				пНоваяСтрока.Отличие = "ВесЧислитель";
				пНоваяСтрока.Описание = "Вес/ед.изм. веса";
			КонецЕсли;
			 
			Если ИтоговаяВыборка.Объем или ИтоговаяВыборка.ОбъемЕдИзм Тогда
				пНоваяСтрока = пстрРодитель.Строки.Добавить();
				пНоваяСтрока.Номенклатура = ИтоговаяВыборка.Номенклатура;
				пНоваяСтрока.НоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей;
				пНоваяСтрока.ПолеНоменклатура = ИтоговаяВыборка.Номенклатура.ОбъемЧислитель;
				пНоваяСтрока.ПолеНоменклатураПроизводителя = ИтоговаяВыборка.НоменклатураПроизводителей.ОбъемБазовой;
 				пНоваяСтрока.Отличие = "ОбъемЧислитель";
				пНоваяСтрока.Описание = "Объем/ед.изм. объема";
			КонецЕсли;
				 
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(тзДляИсправления,"ТаблицаСопоставления");
	
	УстановитьУсловноеОформление();
	Возврат пСообщениеОбИзменениях;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьЗамену(Команда)
	ВыполнитьЗаменуНаСервере();
	пСообщение = СопоставитьНоменклатуруНаСервере(Объект.Производитель);
	Сообщить(пСообщение);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗаменуНаСервере()
	ТзДляИсправления = РеквизитФормыВЗначение("ТаблицаСопоставления");
	
	Для Каждого СтрГруппировка из ТзДляИсправления.Строки Цикл
		
		Если СтрГруппировка.Пометка Тогда
			Для Каждого Стр из СтрГруппировка.Строки Цикл 
				
				Если Стр.Пометка Тогда
					
					пОбъектНоменклатура = Стр.Номенклатура.ПолучитьОбъект();
					
					Если Стр.Отличие <> "ОбъемЧислитель" И  Стр.Отличие <> "ВесЧислитель" И Стр.Отличие <> "ЕдиницаИзмеренияУпаковки" Тогда
					//	пОбъектНоменклатура = Стр.Номенклатура.ПолучитьОбъект();
						пОбъектНоменклатура[Стр.Отличие] = Стр.ПолеНоменклатураПроизводителя;
					//	пОбъектНоменклатура.Записать();
					ИначеЕсли  Стр.Отличие = "ОбъемЧислитель" Тогда 
					//	пОбъектНоменклатура = Стр.Номенклатура.ПолучитьОбъект();
						пОбъектНоменклатура.ОбъемЧислитель = Стр.НоменклатураПроизводителя.ОбъемБазовой;
						пОбъектНоменклатура.ОбъемЗнаменатель = 1;
						пОбъектНоменклатура.ОбъемИспользовать = Истина;
						пОбъектНоменклатура.ОбъемЕдиницаИзмерения = Стр.НоменклатураПроизводителя.ЕИОбъема;
					//	пОбъектНоменклатура.Записать();
					ИначеЕсли Стр.Отличие = "ВесЧислитель" Тогда 
					//	пОбъектНоменклатура = Стр.Номенклатура.ПолучитьОбъект();
						пОбъектНоменклатура.ВесЧислитель = Стр.НоменклатураПроизводителя.ВесБазовой;
						пОбъектНоменклатура.ВесЗнаменатель = 1;
						пОбъектНоменклатура.ВесИспользовать = Истина;
						пОбъектНоменклатура.ВесЕдиницаИзмерения = Стр.НоменклатураПроизводителя.ЕИВеса;
					//	пОбъектНоменклатура.Записать();
					
				//{{20200717 ГлазуновДВ Вставили проверку и создание УПАКОВОК!!!
					ИначеЕсли Стр.Отличие = "ЕдиницаИзмеренияУпаковки" Тогда
										//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
						// Данный фрагмент построен конструктором.
						// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
						
						Запрос = Новый Запрос;
						Запрос.Текст = 
							"ВЫБРАТЬ
							|	УпаковкиЕдиницыИзмерения.Ссылка КАК Ссылка
							|ИЗ
							|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
							|ГДЕ
							|	УпаковкиЕдиницыИзмерения.Владелец = &Владелец
							|	И УпаковкиЕдиницыИзмерения.ЕдиницаИзмерения = &ЕдиницаИзмерения
							|	И УпаковкиЕдиницыИзмерения.Числитель = &Числитель
							|	И УпаковкиЕдиницыИзмерения.Знаменатель = &Знаменатель";
						
						Запрос.УстановитьПараметр("Владелец", Стр.Номенклатура);
						Запрос.УстановитьПараметр("ЕдиницаИзмерения", Стр.НоменклатураПроизводителя.ОсновнаяЕдиницаИзмерения);
						Запрос.УстановитьПараметр("Числитель", Стр.НоменклатураПроизводителя.КоэффициентОсновнойЕдИзм);
						Запрос.УстановитьПараметр("Знаменатель", 1);
						
						РезультатЗапроса = Запрос.Выполнить();
						
						ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
						
						Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
							// Вставить обработку выборки ВыборкаДетальныеЗаписи
						КонецЦикла;
						
						Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
	
							пЕдИзмВеса = Справочники.УпаковкиЕдиницыИзмерения.НайтиПоКоду("166");//кг
							пЕдИзмМетр = Справочники.УпаковкиЕдиницыИзмерения.НайтиПоКоду("006");//м
							пЕдИзмОбъем = Справочники.УпаковкиЕдиницыИзмерения.НайтиПоКоду("113"); //м3
							
							пУпаковкиОбъект = Справочники.УпаковкиЕдиницыИзмерения.СоздатьЭлемент();
							пУпаковкиОбъект.Владелец = Стр.Номенклатура;
							пУпаковкиОбъект.ЕдиницаИзмерения = Стр.НоменклатураПроизводителя.ОсновнаяЕдиницаИзмерения;
							пУпаковкиОбъект.Числитель = Стр.НоменклатураПроизводителя.КоэффициентОсновнойЕдИзм;
							пУпаковкиОбъект.Знаменатель = 1;
							пУпаковкиОбъект.Наименование = "упак (" + Стр.НоменклатураПроизводителя.КоэффициентОсновнойЕдИзм + " " + Стр.НоменклатураПроизводителя.БазоваяЕдиницаИзмерения + ")";
							пУпаковкиОбъект.Безразмерная = Ложь;
							пУпаковкиОбъект.ВесЕдиницаИзмерения = пЕдИзмВеса;
							пУпаковкиОбъект.ГлубинаЕдиницаИзмерения = пЕдИзмМетр;
							пУпаковкиОбъект.ШиринаЕдиницаИзмерения = пЕдИзмМетр;
							пУпаковкиОбъект.ОбъемЕдиницаИзмерения = пЕдИзмОбъем;
							пУпаковкиОбъект.ВысотаЕдиницаИзмерения = пЕдИзмМетр;
							пУпаковкиОбъект.ПоставляетсяВМногооборотнойТаре = Ложь;
							пУпаковкиОбъект.ТипИзмеряемойВеличины =  Перечисления.ТипыИзмеряемыхВеличин.Упаковка;
							пУпаковкиОбъект.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Конечная;
							пУпаковкиОбъект.НаименованиеПолное = пУпаковкиОбъект.Наименование;			
							Попытка
								пУпаковкиОбъект.Записать();
							Исключение
							КонецПопытки;
							
							Если Не Стр.Номенклатура.ИспользоватьУпаковки Тогда
								пОбъектНоменклатура.ИспользоватьУпаковки = Истина;
							КонецЕсли;
							
						//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
						КонецЕсли;			
				//}}20200717 ГлазуновДВ
					КонецЕсли;
					
					Попытка
						пОбъектНоменклатура.Записать();
					Исключение
					КонецПопытки;
						
				КонецЕсли;
					
			  КонецЦикла;
				
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСопоставленияПометкаПриИзменении(Элемент)
	
	ИДТекущейСтроки = Элементы.ТаблицаСопоставления.ТекущаяСтрока;
	Если ИДТекущейСтроки <> Неопределено Тогда
		
		 ЭлементКоллекции = ЭтаФорма.ТаблицаСопоставления.НайтиПоИдентификатору(ИДТекущейСтроки);
	     Родитель = ЭлементКоллекции.ПолучитьРодителя();
         Если Родитель <> Неопределено Тогда 
			 Если ЭлементКоллекции.Пометка Тогда
				 Родитель.Пометка = Истина;
				 УстановитьПометкуДляПодчиненных(Родитель,ЭлементКоллекции.Пометка);
			 КонецЕсли;	
		 Иначе
			 УстановитьПометкуДляПодчиненных(ЭлементКоллекции,ЭлементКоллекции.Пометка);
		 КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция УстановитьПометкуДляПодчиненных(ЭлементКоллекции,Пометка)

    СоседниеЭлементы = ЭлементКоллекции.ПолучитьЭлементы();
    Для Каждого ТекЭлемент Из СоседниеЭлементы Цикл
       ТекЭлемент.Пометка = Пометка;
    КонецЦикла;
   
КонецФункции

&НаКлиенте
Процедура ТаблицаСопоставленияНоменклатураПроизводителяПриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСопоставленияНоменклатураСоздание(Элемент, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометку(Команда)
	пСписокУзлов = ТаблицаСопоставления.ПолучитьЭлементы();
//Исходное	Для Каждого Узел из пСписокУзлов Цикл 
//Исходное		    Узел.Пометка = Истина;
//Исходное			УстановитьПометкуДляПодчиненных(Узел,Истина);
//Исходное	КонецЦикла;
//ГлазуновДВ Поменяли процесс выделения строк для Регистрации	
	Для Каждого Узел из пСписокУзлов Цикл 
		    Узел.Пометка = Ложь;
			УстановитьПометкуДляПодчиненных(Узел,Ложь);
	КонецЦикла;
	Для Каждого Стр из Элементы.ТаблицаСопоставления.ВыделенныеСтроки Цикл 
			СтрокаСписка = ТаблицаСопоставления.НайтиПоИдентификатору(Стр);
		    СтрокаСписка.Пометка = Истина;
			СтрРодитель = СтрокаСписка.ПолучитьРодителя();
			//++Шерстюк Ю.Ю. 11.03.21
			Если СтрРодитель <> Неопределено Тогда 
				СтрРодитель.Пометка = Истина; 			
				УстановитьПометкуДляПодчиненных(СтрРодитель,Истина);
			КонецЕсли;                       
			//--Шерстюк Ю.Ю.
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометку(Команда)
	пСписокУзлов = ТаблицаСопоставления.ПолучитьЭлементы();
	Для Каждого Узел из пСписокУзлов Цикл 
		    Узел.Пометка = Ложь;
			УстановитьПометкуДляПодчиненных(Узел,Ложь);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево(Команда)
	 ЭлементыДерева = ТаблицаСопоставления.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
	    Элементы.ТаблицаСопоставления.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СвернутьДерево(Команда)
	ЭлементыДерева = ТаблицаСопоставления.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
	    Элементы.ТаблицаСопоставления.Свернуть(ЭлементДерева.ПолучитьИдентификатор());
	КонецЦикла;

КонецПроцедуры
