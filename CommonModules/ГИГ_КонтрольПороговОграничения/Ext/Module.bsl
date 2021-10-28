﻿

Процедура ВыполнитьПроверкуПоПорогамЦеновыхГрупп(Отказ,Объект,РежимПроведения) Экспорт 
	
	Если ТипЗнч(Объект) = тип("ДокументОбъект.ЗаказКлиента") тогда
		ПеречисленияСтатуса = Перечисления.СтатусыЗаказовКлиентов.КОбеспечению;
	ИначеЕсли ТипЗнч(Объект) = тип("ДокументОбъект.КоммерческоеПредложениеКлиенту") тогда
        ПеречисленияСтатуса = Перечисления.СтатусыКоммерческихПредложенийКлиентам.Действует;
	ИначеЕсли ТипЗнч(Объект) = тип("ДокументОбъект.РеализацияТоваровУслуг") тогда
		ПеречисленияСтатуса = Объект.Статус;
	КонецЕсли;	
	
	ИмяДокумента = Объект.Метаданные().Синоним + " " + Объект.Номер + " от " + Формат(Объект.Дата, "ДФ=dd.MM.yyyy");
	
	Если Объект.Статус = ПеречисленияСтатуса Тогда 
		ТаблицаДанных = ПолучитьДанныеПоПорога(Объект);
		Если ТаблицаДанных = Неопределено тогда
			
		Иначе
			Если ТаблицаДанных.Количество() <> 0 тогда 
				ТаблицаДанных.Сортировать("НомерСтроки Возр");
				Для Каждого СтрокаТаблицы из ТаблицаДанных цикл
					Если СтрокаТаблицы.СкидкаДокумента <> Null тогда
						Если СтрокаТаблицы.СкидкаДокумента > СтрокаТаблицы.ДопустимаяСкидка Тогда 
							Если СтрокаТаблицы.Действие = "Запрет" или СтрокаТаблицы.Действие = Null  Тогда 
								ОписаниеПорога = ?(СтрокаТаблицы.ПорогОграничения = Null,Справочники.ГИГ_ПорогиОграничений.СкидкаПоставщикаОтТарифа,СтрокаТаблицы.ПорогОграничения);
								Сообщение = Новый СообщениеПользователю;
								Сообщение.Текст =   "Установлен запрет на запись документа " +ИмяДокумента+ " в статусе ""К выполнению""!"+Символы.ПС+
													"В строке № "+СтрокаТаблицы.НомерСтроки+" Превышен размер скидки/наценки "+СтрокаТаблицы.ДопустимаяСкидка+"% по порогу: "+ОписаниеПорога+"."+Символы.ПС+ 
													"По ценовой группе: "+СтрокаТаблицы.НоменклатураЦеноваяГруппа+" по номенклатуре: "+ СтрокаТаблицы.Номенклатура;
								Сообщение.Сообщить();
								
								Отказ = Истина;
							иначе
								ОписаниеПорога = ?(СтрокаТаблицы.ПорогОграничения = Null,Справочники.ГИГ_ПорогиОграничений.СкидкаПоставщикаОтТарифа,СтрокаТаблицы.ПорогОграничения);
								Сообщение = Новый СообщениеПользователю;
								Сообщение.Текст =   "Внимание! " +ИмяДокумента+ ". В строке № "+СтрокаТаблицы.НомерСтроки+" Превышен размер скидки/наценки "+СтрокаТаблицы.ДопустимаяСкидка+"% по порогу: "+ОписаниеПорога+"."+Символы.ПС+ 
													"По ценовой группе: "+СтрокаТаблицы.НоменклатураЦеноваяГруппа+" по номенклатуре: "+ СтрокаТаблицы.Номенклатура;
								//++Гольм А.А. (Гигабайт)
								ВыводитьСообщение = Истина;
								Если ТипЗнч(Объект) = Тип("ДокументОбъект.ЗаказКлиента") Тогда
									Если Объект.ДополнительныеСвойства.Свойство("ПроведениеРеализацииТоваровУслуг") И Объект.ДополнительныеСвойства.ПроведениеРеализацииТоваровУслуг Тогда
										ВыводитьСообщение = Ложь;
									КонецЕсли;
								КонецЕсли;
								Если ВыводитьСообщение Тогда
									Сообщение.Сообщить();
								КонецЕсли;
								//--Гольм А.А. (Гигабайт)
								Отказ = Ложь;
							КонецЕсли;	
						КонецЕсли;	
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;	
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьДанныеПоПорога(ТекущийОбъект)
	Список = Новый СписокЗначений;
	Список.Добавить(Пользователи.ТекущийПользователь());
	ЗапроспоГруппам = Новый Запрос;
	ЗапроспоГруппам.Текст = "ВЫБРАТЬ
							|	ГруппыПользователейСостав.Ссылка
							|ИЗ
							|	Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
							|ГДЕ
							|	ГруппыПользователейСостав.Пользователь = &Пользователь";
	ЗапроспоГруппам.УстановитьПараметр("Пользователь",Пользователи.ТекущийПользователь());  	
	РезультатПоГруппам = ЗапроспоГруппам.Выполнить().Выбрать();
	Пока РезультатПоГруппам.Следующий() Цикл 
		Список.Добавить(РезультатПоГруппам.Ссылка);
	КонецЦикла;	
	
	СписокСхем = Новый СписокЗначений;
	ЗапросСхемы = Новый Запрос;
	ЗапросСхемы.Текст = "ВЫБРАТЬ
						|	НастройкиПродажДляПользователей.СхемаОграничения
						|ИЗ
						|	Справочник.НастройкиПродажДляПользователей КАК НастройкиПродажДляПользователей
						|ГДЕ
						|	НастройкиПродажДляПользователей.Владелец В(&Пользователь)";
	ЗапросСхемы.УстановитьПараметр("Пользователь",Список);
	РезультатПоСхемам = ЗапросСхемы.Выполнить().Выбрать();
	Пока  РезультатПоСхемам.Следующий() цикл 
		Если РезультатПоСхемам.СхемаОграничения <> Справочники.ГИГ_СхемыОграниченийПродаж.ПустаяСсылка() Тогда 
		СписокСхем.Добавить(РезультатПоСхемам.СхемаОграничения);
		КонецЕсли;
	КонецЦикла;	
	Если СписокСхем.Количество() <> 0 Тогда 
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДатаЗапроса",ТекущийОбъект.Дата);
		Запрос.УстановитьПараметр("СсылкаЗаказ",ТекущийОбъект.Ссылка);
		Запрос.УстановитьПараметр("ПорогОграниченияОсновной",Справочники.ГИГ_ПорогиОграничений.СкидкаПоставщикаОтТарифа);
		Запрос.УстановитьПараметр("ПризнакДействия",1);
		Если ТипЗнч(ТекущийОбъект) = тип("ДокументОбъект.ЗаказКлиента") тогда
			ПеременнаяДокумента = " Документ.ЗаказКлиента.Товары ";
		ИначеЕсли ТипЗнч(ТекущийОбъект) = тип("ДокументОбъект.КоммерческоеПредложениеКлиенту") тогда
			ПеременнаяДокумента = " Документ.КоммерческоеПредложениеКлиенту.Товары ";
		ИначеЕсли ТипЗнч(ТекущийОбъект) = тип("ДокументОбъект.РеализацияТоваровУслуг") тогда
			ПеременнаяДокумента = " Документ.РеализацияТоваровУслуг.Товары ";
		КонецЕсли;	
		Запрос.УстановитьПараметр("СхемаОграничения",СписокСхем);
		Запрос.УстановитьПараметр("ЗначениеНоль","");
		Запрос.Текст = 
					"ВЫБРАТЬ
					|	ГИГ_СхемыОграниченийПродажНастройкиОграничений.ПорогОграничения КАК ПорогОграничения,
					|	ГИГ_СхемыОграниченийПродажНастройкиОграничений.Действие КАК Действие
					|ПОМЕСТИТЬ ВТ_СписокПорогов
					|ИЗ
					|	Справочник.ГИГ_СхемыОграниченийПродаж.НастройкиОграничений КАК ГИГ_СхемыОграниченийПродажНастройкиОграничений
					|ГДЕ
					|	ГИГ_СхемыОграниченийПродажНастройкиОграничений.Ссылка В(&СхемаОграничения)
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ЗаказКлиентаТовары.Номенклатура.ЦеноваяГруппа
					|ПОМЕСТИТЬ ВТ_СвернутыеЦеновые
					|ИЗ
					|	"+ПеременнаяДокумента+" КАК ЗаказКлиентаТовары
					|ГДЕ
					|	ЗаказКлиентаТовары.Ссылка = &СсылкаЗаказ
					|
					|СГРУППИРОВАТЬ ПО
					|	ЗаказКлиентаТовары.Номенклатура.ЦеноваяГруппа
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ЗаказКлиентаТовары.Номенклатура,
					|	ЗаказКлиентаТовары.Номенклатура.ЦеноваяГруппа КАК НоменклатураЦеноваяГруппа,
					|	ЕСТЬNULL(ЗаказКлиентаТовары.ПроцентРучнойСкидки, 0) + ЕСТЬNULL(ЗаказКлиентаТовары.ПроцентАвтоматическойСкидки, 0) КАК ПроцентСкидки,
					|	ЗаказКлиентаТовары.НомерСтроки
					|ПОМЕСТИТЬ ВТ_СписокЦеновых
					|ИЗ
					|	"+ПеременнаяДокумента+" КАК ЗаказКлиентаТовары
					|ГДЕ
					|	ЗаказКлиентаТовары.Ссылка = &СсылкаЗаказ
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ГИГ_ЗначенияПороговОграниченийСрезПоследних.ЦеноваяГруппа КАК ЦеноваяГруппа,
					|	СУММА(ЕСТЬNULL(ГИГ_ЗначенияПороговОграниченийСрезПоследних.Значение, 0)) КАК Значение
					|ПОМЕСТИТЬ ВТ_СкидкаТарифа
					|ИЗ
					|	ВТ_СвернутыеЦеновые КАК ВТ_СвернутыеЦеновые
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГИГ_ЗначенияПороговОграничений.СрезПоследних(
					|				&ДатаЗапроса,
					|				ЦеноваяГруппа В
					|					(ВЫБРАТЬ
					|						СписокЦеновых.НоменклатураЦеноваяГруппа
					|					ИЗ
					|						ВТ_СписокЦеновых КАК СписокЦеновых)) КАК ГИГ_ЗначенияПороговОграниченийСрезПоследних
					|		ПО ВТ_СвернутыеЦеновые.НоменклатураЦеноваяГруппа = ГИГ_ЗначенияПороговОграниченийСрезПоследних.ЦеноваяГруппа
					|ГДЕ
					|	ГИГ_ЗначенияПороговОграниченийСрезПоследних.ПорогОграничения = &ПорогОграниченияОсновной
					|
					|СГРУППИРОВАТЬ ПО
					|	ГИГ_ЗначенияПороговОграниченийСрезПоследних.ЦеноваяГруппа
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ВТ_СписокПорогов.Действие КАК Действие,
					|	ЗапросСвязиСЦеновыми.ЦеноваяГруппа КАК ЦеноваяГруппа,
					|	ЗапросСвязиСЦеновыми.ПорогОграничения КАК ПорогОграничения,
					|	СУММА(ЕСТЬNULL(ЗапросСвязиСЦеновыми.Значение, 0)) КАК Значение
					|ПОМЕСТИТЬ ВТ_ЗначенияСкидокПоПорогам
					|ИЗ
					|	ВТ_СписокПорогов КАК ВТ_СписокПорогов
					|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
					|			ГИГ_ЗначенияПороговОграниченийСрезПоследних.ЦеноваяГруппа КАК ЦеноваяГруппа,
					|			ГИГ_ЗначенияПороговОграниченийСрезПоследних.ПорогОграничения КАК ПорогОграничения,
					|			ЕСТЬNULL(ГИГ_ЗначенияПороговОграниченийСрезПоследних.Значение, 0) КАК Значение
					|		ИЗ
					|			ВТ_СвернутыеЦеновые КАК ВТ_СвернутыеЦеновые
					|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГИГ_ЗначенияПороговОграничений.СрезПоследних(
					|						&ДатаЗапроса,
					|						ЦеноваяГруппа В
					|							(ВЫБРАТЬ
					|								СписокЦеновых.НоменклатураЦеноваяГруппа
					|							ИЗ
					|								ВТ_СписокЦеновых КАК СписокЦеновых)) КАК ГИГ_ЗначенияПороговОграниченийСрезПоследних
					|				ПО ВТ_СвернутыеЦеновые.НоменклатураЦеноваяГруппа = ГИГ_ЗначенияПороговОграниченийСрезПоследних.ЦеноваяГруппа) КАК ЗапросСвязиСЦеновыми
					|		ПО ВТ_СписокПорогов.ПорогОграничения = ЗапросСвязиСЦеновыми.ПорогОграничения
					|ГДЕ
					|	ЗапросСвязиСЦеновыми.Значение <> &ЗначениеНоль
					|
					|СГРУППИРОВАТЬ ПО
					|	ВТ_СписокПорогов.Действие,
					|	ЗапросСвязиСЦеновыми.ЦеноваяГруппа,
					|	ЗапросСвязиСЦеновыми.ПорогОграничения
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
					|	ЗаказКлиентаТовары.Номенклатура.ЦеноваяГруппа КАК НоменклатураЦеноваяГруппа,
					|	ЕСТЬNULL(ЗаказКлиентаТовары.ПроцентРучнойСкидки, 0) + ЕСТЬNULL(ЗаказКлиентаТовары.ПроцентАвтоматическойСкидки, 0) КАК СкидкаДокумента,
					|	ВТ_ЗначенияСкидокПоПорогам.Действие КАК Действие,
					|	ВТ_ЗначенияСкидокПоПорогам.Значение КАК ЗначениеПорога,
					|	ЕСТЬNULL(ВТ_СкидкаТарифа.Значение, 0) КАК ЗначениетарифаПоставщика,
					|	ЕСТЬNULL(ВТ_СкидкаТарифа.Значение, 0) - ЕСТЬNULL(ВТ_ЗначенияСкидокПоПорогам.Значение, 0) КАК ДопустимаяСкидка,
					|	ВЫБОР
					|		КОГДА ВТ_ЗначенияСкидокПоПорогам.Действие = ""Запрет""
					|			ТОГДА 2
					|		ИНАЧЕ 1
					|	КОНЕЦ КАК ЧислоДействия,
					|	ВТ_ЗначенияСкидокПоПорогам.ПорогОграничения,
					|	ЗаказКлиентаТовары.НомерСтроки
					|ПОМЕСТИТЬ ВТ_ДанныеЗаказа
					|ИЗ
					|	"+ПеременнаяДокумента+" КАК ЗаказКлиентаТовары
					|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ЗначенияСкидокПоПорогам КАК ВТ_ЗначенияСкидокПоПорогам
					|		ПО ЗаказКлиентаТовары.Номенклатура.ЦеноваяГруппа = ВТ_ЗначенияСкидокПоПорогам.ЦеноваяГруппа
					|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СкидкаТарифа КАК ВТ_СкидкаТарифа
					|		ПО ЗаказКлиентаТовары.Номенклатура.ЦеноваяГруппа = ВТ_СкидкаТарифа.ЦеноваяГруппа
					|ГДЕ
					|	ЗаказКлиентаТовары.Ссылка = &СсылкаЗаказ
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ВТ_ДанныеЗаказа.Номенклатура КАК Номенклатура,
					|	ВТ_ДанныеЗаказа.НоменклатураЦеноваяГруппа КАК НоменклатураЦеноваяГруппа,
					|	ВТ_ДанныеЗаказа.СкидкаДокумента КАК СкидкаДокумента,
					|	ВТ_ДанныеЗаказа.Действие КАК Действие,
					|	ВТ_ДанныеЗаказа.ЗначениеПорога КАК ЗначениеПорога,
					|	ВТ_ДанныеЗаказа.ЗначениетарифаПоставщика КАК ЗначениетарифаПоставщика,
					|	ВТ_ДанныеЗаказа.ДопустимаяСкидка КАК ДопустимаяСкидка,
					|	ВЫБОР
					|		КОГДА ВТ_ДанныеЗаказа.СкидкаДокумента > ВТ_ДанныеЗаказа.ДопустимаяСкидка
					|			ТОГДА 1
					|		ИНАЧЕ 0
					|	КОНЕЦ КАК ПризнакДействия,
					|	ВЫБОР
					|		КОГДА ВТ_ДанныеЗаказа.Действие = ""Запрет""
					|			ТОГДА 2
					|		ИНАЧЕ 1
					|	КОНЕЦ КАК ЧислоДействия,
					|	ВТ_ДанныеЗаказа.ПорогОграничения,
					|	ВТ_ДанныеЗаказа.НомерСтроки
					|ПОМЕСТИТЬ ВТ_ДействующиеОграничения
					|ИЗ
					|	ВТ_ДанныеЗаказа КАК ВТ_ДанныеЗаказа
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ВТ_ДействующиеОграничения.Номенклатура,
					|	ВТ_ДействующиеОграничения.НоменклатураЦеноваяГруппа,
					|	ВТ_ДействующиеОграничения.СкидкаДокумента,
					|	ВТ_ДействующиеОграничения.Действие,
					|	ВТ_ДействующиеОграничения.ЗначениеПорога,
					|	ВТ_ДействующиеОграничения.ЗначениетарифаПоставщика,
					|	ВТ_ДействующиеОграничения.ДопустимаяСкидка,
					|	ВТ_ДействующиеОграничения.ПризнакДействия,
					|	ВТ_ДействующиеОграничения.ЧислоДействия,
					|	ВТ_ДействующиеОграничения.ПорогОграничения,
					|	ВТ_ДействующиеОграничения.НомерСтроки
					|ПОМЕСТИТЬ ВТ_ТолькоДействующие
					|ИЗ
					|	ВТ_ДействующиеОграничения КАК ВТ_ДействующиеОграничения
					|ГДЕ
					|	ВТ_ДействующиеОграничения.ПризнакДействия = &ПризнакДействия
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ВТ_ДанныеЗаказа.Номенклатура КАК Номенклатура,
					|	ВТ_ДанныеЗаказа.НоменклатураЦеноваяГруппа КАК НоменклатураЦеноваяГруппа,
					|	ВТ_ДанныеЗаказа.СкидкаДокумента КАК СкидкаДокумента,
					|	ВТ_ДанныеЗаказа.Действие КАК Действие,
					|	ВТ_ДанныеЗаказа.ЗначениеПорога КАК ЗначениеПорога,
					|	ВТ_ДанныеЗаказа.ЗначениетарифаПоставщика КАК ЗначениетарифаПоставщика,
					|	ВТ_ДанныеЗаказа.ДопустимаяСкидка КАК ДопустимаяСкидка,
					|	ВТ_ДанныеЗаказа.ПорогОграничения,
					|	ВТ_ДанныеЗаказа.НомерСтроки
					|ИЗ
					|	(ВЫБРАТЬ
					|		МАКСИМУМ(ВТ_ТолькоДействующие.ДопустимаяСкидка) КАК ДопустимаяСкидка,
					|		ВТ_ТолькоДействующие.НоменклатураЦеноваяГруппа КАК ЦеноваяГруппа,
					|		ВТ_ТолькоДействующие.Номенклатура КАК Номенклатура,
					|		МАКСИМУМ(ВТ_ТолькоДействующие.ПризнакДействия) КАК ЧислоДействия,
					|		ВТ_ТолькоДействующие.НомерСтроки КАК НомерСтроки
					|	ИЗ
					|		ВТ_ТолькоДействующие КАК ВТ_ТолькоДействующие
					|	ГДЕ
					|		ВТ_ТолькоДействующие.ПризнакДействия = &ПризнакДействия
					|	
					|	СГРУППИРОВАТЬ ПО
					|		ВТ_ТолькоДействующие.НоменклатураЦеноваяГруппа,
					|		ВТ_ТолькоДействующие.Номенклатура,
					|		ВТ_ТолькоДействующие.НомерСтроки) КАК ВложенныйЗапрос
					|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеЗаказа КАК ВТ_ДанныеЗаказа
					|		ПО ВложенныйЗапрос.ДопустимаяСкидка = ВТ_ДанныеЗаказа.ДопустимаяСкидка
					|			И ВложенныйЗапрос.ЦеноваяГруппа = ВТ_ДанныеЗаказа.НоменклатураЦеноваяГруппа
					|			И ВложенныйЗапрос.Номенклатура = ВТ_ДанныеЗаказа.Номенклатура
					|			И ВложенныйЗапрос.НомерСтроки = ВТ_ДанныеЗаказа.НомерСтроки";							
		РезультатЗапросаПоДокументу = Запрос.Выполнить().Выгрузить();
		Возврат РезультатЗапросаПоДокументу;
	иначе
		Возврат Неопределено;	
	КонецЕсли;
КонецФункции 
