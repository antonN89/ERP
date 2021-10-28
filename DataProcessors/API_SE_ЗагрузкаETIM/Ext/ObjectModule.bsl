﻿Процедура ВыполнитьЗапрос(СтруктураМетодовЗапроса) Экспорт 
	
		
		АвторизационныйКлюч = "HYHlIz771aID8quFHxxq6gwNLlgcEsiZ";
		
		СтруктураПараметровСоединения = Новый Структура;
		СтруктураПараметровСоединения.Вставить("Сервер",						 "web.se-ecatalog.ru");	
		СтруктураПараметровСоединения.Вставить("Порт",							 443);	
		СтруктураПараметровСоединения.Вставить("Пользователь",					 "");	
		СтруктураПараметровСоединения.Вставить("Пароль",						 "");	
		СтруктураПараметровСоединения.Вставить("Прокси",						 Неопределено);	
		СтруктураПараметровСоединения.Вставить("Таймаут",						 0);	
		
		ssl1 = Новый ЗащищенноеСоединениеOpenSSL(
		Новый СертификатКлиентаWindows(),
		Новый СертификатыУдостоверяющихЦентровWindows());

		СтруктураПараметровСоединения.Вставить("ЗащищенноеСоединение",			 ssl1);
		СтруктураПараметровСоединения.Вставить("ИспользоватьАутентификациюОС",	 Ложь);
	
		Для каждого Стр Из СтруктураМетодовЗапроса Цикл
			
           Если Стр.Ключ = "getdata" Тогда 
				Если ЗначениеЗаполнено(Номенклатура) Тогда 
					HTTPАдресРесурса = СтруктураМетодовЗапроса["getdata"] + "commercialRef=" + СокрЛП(Номенклатура.Артикул) + "&accessCode=" + СокрЛП(АвторизационныйКлюч) ;
				
					СтруктураПараметровЗапроса = Новый Структура;
					СтруктураПараметровЗапроса.Вставить("АдресРесурса",	СокрЛП(HTTPАдресРесурса));	
					СтруктураПараметровЗапроса.Вставить("Заголовки",	Новый Соответствие);
					//
					РезультатGetЗапрос = ВыполнитьGetЗапрос(СтруктураПараметровСоединения, СтруктураПараметровЗапроса);
					
					ПрочитатьФайлXMLЧерезDOM_getData(РезультатGetЗапрос.ИмяФайлаОтвета);
				Иначе
					 HTTPАдресРесурса = СтруктураМетодовЗапроса["getdata"] + "&accessCode=" + СокрЛП(АвторизационныйКлюч) + "&pageSize=100&page=";
					пНомерСтраницы = 200;
					пПустаяСтраница = Ложь; //переменная примет истина, когда в ответе не будет данных, значит прекратим запросы
					
					Пока Не пПустаяСтраница Цикл 
						СтруктураПараметровЗапроса = Новый Структура;
						
						HTTPАдресРесурсаСтраница = HTTPАдресРесурса + Строка(пНомерСтраницы);
						
						СтруктураПараметровЗапроса.Вставить("АдресРесурса",	СокрЛП(HTTPАдресРесурсаСтраница));	
						СтруктураПараметровЗапроса.Вставить("Заголовки",	Новый Соответствие);
						
						РезультатGetЗапрос = ВыполнитьGetЗапрос(СтруктураПараметровСоединения, СтруктураПараметровЗапроса);
						
						пПустаяСтраница = ПрочитатьФайлXMLЧерезDOM_getData(РезультатGetЗапрос.ИмяФайлаОтвета);
						
						пРезультат = СопоставитьНоменклатуру(ЭтотОбъект.Результат.Выгрузить());
						ЭтотОбъект.Результат.Загрузить(пРезультат);
						ЗаписатьETIM();
						пНомерСтраницы = пНомерСтраницы + 1;
					КонецЦикла;

				КонецЕсли;
				
			КонецЕсли;
			
			Попытка
				УдалитьФайлы(РезультатGetЗапрос.ИмяФайлаОтвета);
			Исключение
				СообщитьПользователю(ОписаниеОшибки());
			КонецПопытки;
			
		КонецЦикла;
		
		ДанныеОбработаны = Истина;
		
	КонецПроцедуры
	
Функция  СопоставитьНоменклатуру(Таблица) Экспорт 
	
	пЗапрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
|	Таблица.КлассAPI КАК КлассAPI,
|	Таблица.СвойствоAPI КАК СвойствоAPI,
|	Таблица.Артикул КАК Артикул,
|	Таблица.ЗначениеAPI КАК ЗначениеAPI,
|	Таблица.ЗначениеR1_API КАК ЗначениеR1_API,
|	Таблица.Значение_R_API КАК Значение_R_API,
|	Таблица.Value_RZ КАК Value_RZ
|ПОМЕСТИТЬ ТаблицаAPI
|ИЗ
|	&Таблица КАК Таблица
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ РАЗРЕШЕННЫЕ
|	Номенклатура.Ссылка КАК Номенклатура
|ПОМЕСТИТЬ СправочникНоменклатура
|ИЗ
|	Справочник.Номенклатура КАК Номенклатура
|ГДЕ
|	Номенклатура.Производитель = &Производитель
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ РАЗРЕШЕННЫЕ
|	СопоставленнаяНоменклатура.Номенклатура КАК Номенклатура,
|	Рин1_ГруппыКлассыETIM.Ссылка КАК КлассСсылка,
|	ТаблицаAPI.Артикул КАК Артикул,
|	Рин1_ГруппыКлассыETIM.ПредставлениеГруппыКласса КАК КлассПредставление,
|	ТаблицаAPI.КлассAPI КАК КлассAPI,
|	ТаблицаAPI.СвойствоAPI КАК СвойствоAPI,
|	Рин1_ГруппыКлассыETIM.Родитель.ПредставлениеГруппыКласса КАК ГруппаПредставление,
|	ТаблицаAPI.ЗначениеAPI КАК ЗначениеAPI,
|	ТаблицаAPI.ЗначениеR1_API КАК ЗначениеR1_API,
|	ТаблицаAPI.Значение_R_API КАК Значение_R_API,
|	ТаблицаAPI.Value_RZ КАК Value_RZ
|ПОМЕСТИТЬ НоменклатураКлассETIM
|ИЗ
|	ТаблицаAPI КАК ТаблицаAPI
|		ЛЕВОЕ СОЕДИНЕНИЕ СправочникНоменклатура КАК СопоставленнаяНоменклатура
|		ПО (ПОДСТРОКА(ТаблицаAPI.Артикул, 1, 100) = ПОДСТРОКА(СопоставленнаяНоменклатура.Номенклатура.Артикул, 1, 100))
|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Рин1_ГруппыКлассыETIM КАК Рин1_ГруппыКлассыETIM
|		ПО (ПОДСТРОКА(ТаблицаAPI.КлассAPI, 1, 100) = ПОДСТРОКА(Рин1_ГруппыКлассыETIM.Наименование, 1, 100))
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	НоменклатураКлассETIM.Номенклатура КАК Номенклатура,
|	НоменклатураКлассETIM.КлассПредставление КАК КлассПредставление,
|	НоменклатураКлассETIM.КлассAPI КАК КлассAPI,
|	НоменклатураКлассETIM.СвойствоAPI КАК СвойствоAPI,
|	Рин1_СвойстваКлассаETIM.Ссылка КАК Свойство,
|	Рин1_СвойстваКлассаETIM.ПредставлениеСвойства КАК СвойствоПредставление,
|	НоменклатураКлассETIM.ГруппаПредставление КАК ГруппаПредставление,
|	ВЫБОР
|		КОГДА Рин1_СвойстваКлассаETIM.ТИП = ЗНАЧЕНИЕ(Перечисление.Рин1_ТипСвойства.A)
|			ТОГДА НоменклатураКлассETIM.ЗначениеAPI
|		ИНАЧЕ """"
|	КОНЕЦ КАК Value_A,
|	ВЫБОР
|		КОГДА Рин1_СвойстваКлассаETIM.ТИП = ЗНАЧЕНИЕ(Перечисление.Рин1_ТипСвойства.N)
|			ТОГДА НоменклатураКлассETIM.ЗначениеAPI
|		ИНАЧЕ """"
|	КОНЕЦ КАК Value_N,
|	ВЫБОР
|		КОГДА Рин1_СвойстваКлассаETIM.ТИП = ЗНАЧЕНИЕ(Перечисление.Рин1_ТипСвойства.L)
|			ТОГДА НоменклатураКлассETIM.ЗначениеAPI
|		ИНАЧЕ """"
|	КОНЕЦ КАК Value_L,
|	ВЫБОР
|		КОГДА Рин1_СвойстваКлассаETIM.ТИП = ЗНАЧЕНИЕ(Перечисление.Рин1_ТипСвойства.R)
|			ТОГДА НоменклатураКлассETIM.Значение_R_API
|		ИНАЧЕ 0
|	КОНЕЦ КАК Value_R,
|	ВЫБОР
|		КОГДА Рин1_СвойстваКлассаETIM.ТИП = ЗНАЧЕНИЕ(Перечисление.Рин1_ТипСвойства.R)
|			ТОГДА НоменклатураКлассETIM.ЗначениеR1_API
|		ИНАЧЕ 0
|	КОНЕЦ КАК Value_R1,
|	НоменклатураКлассETIM.Value_RZ КАК Value_RZ
|ПОМЕСТИТЬ СвойстваETIM
|ИЗ
|	НоменклатураКлассETIM КАК НоменклатураКлассETIM
|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Рин1_СвойстваКлассаETIM КАК Рин1_СвойстваКлассаETIM
|		ПО (Рин1_СвойстваКлассаETIM.Владелец = НоменклатураКлассETIM.КлассСсылка)
|			И (ПОДСТРОКА(НоменклатураКлассETIM.СвойствоAPI, 1, 100) = ПОДСТРОКА(Рин1_СвойстваКлассаETIM.Наименование, 1, 100))
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	СвойстваETIM.Номенклатура КАК Номенклатура,
|	СвойстваETIM.КлассПредставление КАК КлассПредставление,
|	СвойстваETIM.КлассAPI КАК КлассAPI,
|	СвойстваETIM.СвойствоAPI КАК СвойствоAPI,
|	СвойстваETIM.Свойство КАК Свойство,
|	СвойстваETIM.СвойствоПредставление КАК СвойствоПредставление,
|	СвойстваETIM.ГруппаПредставление КАК ГруппаПредставление,
|	Рин1_СвойстваКлассаETIMValue.ПредставлениеЗначения КАК Value_A,
|	СвойстваETIM.Value_N КАК Value_N,
|	СвойстваETIM.Value_L КАК Value_L,
|	СвойстваETIM.Value_R КАК Value_R,
|	СвойстваETIM.Value_R1 КАК Value_R1,
|	СвойстваETIM.Value_RZ КАК Value_RZ
|ИЗ
|	СвойстваETIM КАК СвойстваETIM
|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Рин1_СвойстваКлассаETIM.Value КАК Рин1_СвойстваКлассаETIMValue
|		ПО (СвойстваETIM.Свойство = Рин1_СвойстваКлассаETIMValue.Ссылка
|				И СвойстваETIM.Value_A = Рин1_СвойстваКлассаETIMValue.Value_A)
|ГДЕ
|	(СвойстваETIM.Value_A <> """"
|			ИЛИ СвойстваETIM.Value_N <> """"
|			ИЛИ СвойстваETIM.Value_L <> """"
|			ИЛИ СвойстваETIM.Value_RZ <> """")
|	И ЕСТЬNULL(СвойстваETIM.Номенклатура, 0) <> 0");
	
	пЗапрос.УстановитьПараметр("Таблица",Таблица);
	пЗапрос.УстановитьПараметр("Производитель",ЭтотОбъект.Производитель);

	Возврат пЗапрос.Выполнить().Выгрузить();	
КонецФункции

	
Процедура ЗаписатьETIM()  Экспорт
	пТаблица = ЭтотОбъект.Результат;
	
	Для Каждого Стр из пТаблица Цикл
		Если Не ЗначениеЗаполнено(Стр.Номенклатура) Тогда
			 Продолжить;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Стр.Номенклатура.КлассETIM) Тогда 
			пОбъектНоменклатура = Стр.Номенклатура.ПолучитьОбъект();
			пОбъектНоменклатура.КлассETIM = Стр.Свойство.Владелец;
			пОбъектНоменклатура.Записать();
		КонецЕсли;
			Запись = РегистрыСведений.Рин1_ЗначенияСвойствНоменклатуры.СоздатьМенеджерЗаписи();
			Запись.Номенклатура = Стр.Номенклатура;
			Запись.Свойство = Стр.Свойство;
			Запись.Прочитать();  
			ЗаполнитьЗначенияСвойств(Запись,Стр);
            Запись.Записать();
			
		//КонецЕсли;
	КонецЦикла;
	ЭтотОбъект.Результат.Очистить();
КонецПроцедуры
	
	
Функция ВыполнитьGetЗапрос(СтруктураПараметровСоединения, СтруктураПараметровЗапроса) 
	
	ИмяФайлаОтвета = ПолучитьИмяВременногоФайла(".xml");
	ИмяФайлаЗапроса = ПолучитьИмяВременногоФайла(".xml");
	
	// Создаем новое HTTP соединение с указанием сервера
	// Последний параметр отвечает за использование защищенного соединения
	HTTPСоединение = Новый HTTPСоединение(СтруктураПараметровСоединения.Сервер, СтруктураПараметровСоединения.Порт, 
	СтруктураПараметровСоединения.Пользователь, СтруктураПараметровСоединения.Пароль, 
	СтруктураПараметровСоединения.Прокси, СтруктураПараметровСоединения.Таймаут, 
	СтруктураПараметровСоединения.ЗащищенноеСоединение, СтруктураПараметровСоединения.ИспользоватьАутентификациюОС);
	
	// Записываем содержимое тела в файл отправки
	ТекстовыйФайл = Новый ТекстовыйДокумент;
	ТекстовыйФайл.УстановитьТекст(СтруктураПараметровЗапроса.АдресРесурса);          
	ТекстовыйФайл.Записать(ИмяФайлаЗапроса, КодировкаТекста.UTF8);
	ФайлОтправки = Новый Файл(ИмяФайлаЗапроса);
	
	// Отсылаем POST запрос на обработку.
	// АдресРесурса — ссылка на веб-сервер (страницу), к которой посылается POST запрос
	// Выполним POST запрос через URL
	HTTPЗапрос = Новый HTTPЗапрос(СтруктураПараметровЗапроса.АдресРесурса, СтруктураПараметровЗапроса.Заголовки);     
	HTTPЗапрос.УстановитьИмяФайлаТела(ИмяФайлаЗапроса);
	
	HTTPОтвет = HTTPСоединение.Получить(HTTPЗапрос, ИмяФайлаОтвета);
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайлаОтвета, КодировкаТекста.UTF8);
	
	ТекстОтвета = ТекстовыйДокумент.ПолучитьТекст();
		
	РезультатGetЗапрос = Новый Структура;
	РезультатGetЗапрос.Вставить("HTTPОтвет", HTTPОтвет);
	РезультатGetЗапрос.Вставить("ТекстОтвета", ТекстОтвета);	
	РезультатGetЗапрос.Вставить("ИмяФайлаОтвета", ИмяФайлаОтвета);	
	
	// Обнулим запрос, чтобы освободить чтение ИмяФайлаЗапроса!
	HTTPЗапрос = Неопределено;
	
	Попытка
		УдалитьФайлы(ИмяФайлаЗапроса);
	Исключение
		СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат РезультатGetЗапрос;
	
КонецФункции	
	

Функция  ПрочитатьФайлXMLЧерезDOM_getData(ПутьКФайлу)
// Разбор документа через DOM (document object model)
	
	Парсер = Новый ЧтениеXML;
	Парсер.ОткрытьФайл(ПутьКФайлу);
	
	Построитель = Новый ПостроительDOM;
	
	Документ = Построитель.Прочитать(Парсер);
	
	пЕстьДанныеНаСтранице = Ложь;
		
	Для Каждого Элемент Из Документ.ЭлементДокумента.ДочерниеУзлы Цикл
		
		// Проверка на успешную загрузку
		Если Элемент.ИмяУзла = "result" Тогда
			
			Если Элемент.ТекстовоеСодержимое = "success" Тогда
				// Файл загрузился корректно!
				Продолжить;	
			Иначе
				СообщитьПользователю("Ответ поставщика содержит ошибки. Обратитесь к разработчику!");
				Возврат Истина; //прервем постраничное формирование запроса
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
		//
		Если Элемент.ИмяУзла = "data" Тогда
			
			пЕстьДанныеНаСтранице = Истина;
			
			Если Элемент.ДочерниеУзлы.Количество() = 0 Тогда
				//ЭтотОбъект.Описание = "Артикул номенклатуры отсутствует в базе данных поставщика!";
				Возврат Истина; //прервем постраничное формирование запроса
				Прервать;
			КонецЕсли;
			
			Для каждого Элемент1 Из Элемент.ДочерниеУзлы Цикл
				
				Если Элемент1.ИмяУзла = "reference" Тогда
					//Добавим строку с артикулом
					Для Каждого Элемент2 из Элемент1.ДочерниеУзлы Цикл
						Если Элемент2.ИмяУзла = "commercialRef" Тогда
                             пАртикул = Элемент2.ТекстовоеСодержимое;
						ИначеЕсли Элемент2.ИмяУзла = "etim" Тогда
							Для Каждого Элемент3 из Элемент2.ДочерниеУзлы Цикл
								Если Элемент3.ИмяУзла = "etim7" Тогда
									
									Для Каждого Элемент4 из Элемент3.ДочерниеУзлы Цикл
										Если Элемент4.ИмяУзла = "class" Тогда
											Для Каждого Элемент5 из Элемент4.ДочерниеУзлы Цикл
												Если Элемент5.ИмяУзла = "id" Тогда
													пКлассAPI = Элемент5.ТекстовоеСодержимое;
												КонецЕсли;
											КонецЦикла;

										ИначеЕсли Элемент4.ИмяУзла = "features" Тогда	
											Для Каждого Элемент5 из Элемент4.ДочерниеУзлы Цикл
												Если Элемент5.ИмяУзла = "feature" Тогда
													Для Каждого Элемент6 из Элемент5.ДочерниеУзлы Цикл
														Если Элемент6.ИмяУзла = "id" Тогда
															 пНоваяСтрока = Результат.Добавить();
                                                             пНоваяСтрока.Артикул = пАртикул;
															 пНоваяСтрока.КлассAPI = пКлассAPI;
															 пНоваяСтрока.СвойствоAPI = Элемент6.ТекстовоеСодержимое;
														 ИначеЕсли Элемент6.ИмяУзла = "value" Тогда
															 пЗначение = Элемент6.ТекстовоеСодержимое;
															 пПозиция = СтрНайти(пЗначение,"...");
															 Если пПозиция = 0 Тогда 
															 	пНоваяСтрока.ЗначениеAPI = пЗначение;
															 Иначе
																  пНоваяСтрока.Значение_R_API = Лев(пЗначение,пПозиция-1);
																  пНоваяСтрока.ЗначениеR1_API = Прав(пЗначение,СтрДлина(пЗначение) - пПозиция-2);
																  пНоваяСтрока.Value_RZ = Строка(пНоваяСтрока.Значение_R_API) + "-" + Строка(пНоваяСтрока.ЗначениеR1_API);
															  КонецЕсли;
														  //ИначеЕсли Элемент6.ИмяУзла = "valueDescriptionRu" и Элемент6.ТекстовоеСодержимое <> "" Тогда  
														  //    пНоваяСтрока.ЗначениеAPI = Элемент6.ТекстовоеСодержимое;
														КонецЕсли;
													КонецЦикла; 
													
												КонецЕсли;

											КонецЦикла;
										КонецЕсли;
									КонецЦикла;
								КонецЕсли;
							КонецЦикла;
						
						КонецЕсли;	 
					КонецЦикла;
				КонецЕсли;
						
			КонецЦикла;
			
		КонецЕсли;
				
	КонецЦикла;
	
	Парсер.Закрыть();
	
	Возврат Не пЕстьДанныеНаСтранице;
КонецФункции

Функция УдалитьЛишниеСимволы(пСтрока)
	
	КоличествоСимволов = СтрДлина(пСтрока);
	пПозиция = 1;
	
	Пока пПозиция <= КоличествоСимволов Цикл
		пКодСимвола = КодСимвола(пСтрока,пПозиция);
		пПозиция = пПозиция + 1;
		Если (пКодСимвола >= 48 и пКодСимвола <= 57) или пКодСимвола = 46 или пКодСимвола = 44 Тогда 
			Продолжить;
		Иначе
			пСтрока = СтрЗаменить(пСтрока,Символ(пКодСимвола),"");
		КонецЕсли;
	КонецЦикла;
	
	Возврат пСтрока;
КонецФункции

// Формирует и выводит сообщение, которое может быть связано с элементом 
// управления формы.
//
//  Параметры
//  ТекстСообщенияПользователю - Строка - Текст сообщения.
//  КлючДанных                 - ЛюбаяСсылка - на объект информационной базы.
//                               Ссылка на объект информационной базы, к которому это сообщение относится,
//                               или ключ записи.
//  Поле                       - Строка - Наименование реквизита формы.
//  ПутьКДанным                - Строка - Путь к данным (путь к реквизиту формы).
//  Отказ                      - Булево - Выходной параметр.
//                               Всегда устанавливается в значение Истина.
//  ИдентификаторНазначения    - УникальныйИдентификатор - Позволяет точно указать,
//                               к какой форме должно быть "привязано" сообщение.
//  ЭтоОбъект                  - Булево - Устанавливает на основе переданного объекта свойства ПутьКДанным и КлючДанных.
//
//	Пример:
//
//	1. Для вывода сообщения у поля управляемой формы, связанного с реквизитом объекта:
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ,
//		"ПолеВРеквизитеФормыОбъект",
//		"Объект");
//
//	Альтернативный вариант использования в форме объекта:
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ,
//		"Объект.ПолеВРеквизитеФормыОбъект");
//
//	2. Для вывода сообщения рядом с полем управляемой формы, связанным с реквизитом формы:
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ,
//		"ИмяРеквизитаФормы");
//
//	3. Для вывода сообщения связанного с объектом информационной базы.
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ОбъектИнформационнойБазы, "Ответственный",,Отказ);
//
// 4. Для вывода сообщения по ссылке на объект информационной базы.
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), Ссылка, , , Отказ);
//
// Случаи некорректного использования:
//  1. Передача одновременно параметров КлючДанных и ПутьКДанным.
//  2. Передача в параметре КлючДанных значения типа отличного от допустимых.
//  3. Установка ссылки без установки поля (и/или пути к данным).
//
Процедура СообщитьПользователю(
	Знач ТекстСообщенияПользователю,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",		
	Отказ = Ложь,
	Знач ИдентификаторНазначения = "",
	Знач ЭтоОбъект = Ложь)
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст		  = ТекстСообщенияПользователю;
	Сообщение.Поле		  = Поле;
	Сообщение.ПутьКДанным = ПутьКДанным;	
	
	Если ЭтоОбъект Тогда
		Сообщение.УстановитьДанные(КлючДанных);
	Иначе
		Сообщение.КлючДанных = КлючДанных;
	КонецЕсли;
	
	Если ТипЗнч(ИдентификаторНазначения) = Тип("УникальныйИдентификатор") Тогда
		Сообщение.ИдентификаторНазначения = ИдентификаторНазначения;
	КонецЕсли;
	
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

