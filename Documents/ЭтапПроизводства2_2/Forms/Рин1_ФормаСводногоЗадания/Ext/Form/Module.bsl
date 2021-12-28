﻿// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	СформироватьПечатнуюФорму(Параметры);
	
	НоваяСтрока = НастройкиПечатныхФорм.Добавить();
	НоваяСтрока.Количество = 1;
	НоваяСтрока.Печатать = Истина;
	НоваяСтрока.ИмяСтраницы = "СтраницаПечатнаяФорма1";
	НоваяСтрока.ИмяРеквизита = "ТабличныйДокумент";
	НоваяСтрока.ИмяМакета = "Рин1_ПФ_СводноеЗадание";
	НоваяСтрока.ПозицияПоУмолчанию = 0;
	НоваяСтрока.Название = "Сводное задание на производство";
	НоваяСтрока.ПутьКМакету = "";
	НоваяСтрока.ИмяФайлаПечатнойФормы = "<Undefined xmlns="""" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:nil=""true""/>";
	НоваяСтрока.ОфисныеДокументы = "";
	НоваяСтрока.ПодписьИПечать = Ложь;
	
	ПараметрыДляОтправки = Новый Структура;
	ПараметрыДляОтправки.Вставить("ДоступнаПечатьПоКомплектно",Ложь);
	ПараметрыДляОтправки.Вставить("ЗаголовокФормы","");
	
	ПараметрыОтправкиСтруктура = Новый Структура;
	
	ПараметрыОтправкиСтруктура.Вставить("Получатель", "");
	ПараметрыОтправкиСтруктура.Вставить("Текст", "");
	ПараметрыОтправкиСтруктура.Вставить("Тема", "");
	
	ПараметрыДляОтправки.Вставить("ПараметрыОтправки",ПараметрыОтправкиСтруктура);
	
	ПараметрыВывода = ПараметрыДляОтправки;
	
КонецПроцедуры

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервере
Процедура СформироватьПечатнуюФорму(Параметры)
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Макет = Документы.ЭтапПроизводства2_2.ПолучитьМакет("Рин1_ПФ_СводноеЗадание");
	
	ДанныеДляЗаполнения = СформироватьДанныеДляЗаполнения(Параметры);
	
	Для Каждого ЭлементЗаказНаПроизводство Из ДанныеДляЗаполнения.Строки Цикл 
		
		ЗаполнитьЗначенияСвойств(МассивЗаказов.Добавить(),ЭлементЗаказНаПроизводство);
		
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
		ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры,ЭлементЗаказНаПроизводство);
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ПроизводимыеИзделияШапка = Макет.ПолучитьОбласть("ПроизводимыеИзделияШапка");
		ТабличныйДокумент.Вывести(ПроизводимыеИзделияШапка);
		
		НомерСпецификации = 1;
		Для Каждого ЭлементСпецификафии Из ЭлементЗаказНаПроизводство.Строки Цикл 
			НоваяСтрока = ТаблицаЭтапов.Добавить();
			НоваяСтрока.Этап = ЭлементСпецификафии.Этап;
			ПроизводимыеИзделияДетальныеЗаписи = Макет.ПолучитьОбласть("ПроизводимыеИзделияДетальныеЗаписи");
			ПроизводимыеИзделияДетальныеЗаписи.Параметры.Номер = НомерСпецификации;
			ПроизводимыеИзделияДетальныеЗаписи.Параметры.СпецификацияАртикул = ЭлементСпецификафии.НоменклатураАртикул;
			ПроизводимыеИзделияДетальныеЗаписи.Параметры.Спецификация = ЭлементСпецификафии.Спецификация;
			ПроизводимыеИзделияДетальныеЗаписи.Параметры.КолВоПлан = ЭлементСпецификафии.Запланировано;
			ПроизводимыеИзделияДетальныеЗаписи.Параметры.КолВоФакт = ЭлементСпецификафии.Выполнено;
			ПроизводимыеИзделияДетальныеЗаписи.Параметры.Этап = ЭлементСпецификафии.Этап;
			ПроизводимыеИзделияДетальныеЗаписи.Параметры.ЕдИзм = ЭлементСпецификафии.НоменклатураЕдиницаИзмерения;
			ПроизводимыеИзделияДетальныеЗаписи.Параметры.ДатаВыполнения = ЭлементСпецификафии.ФактическоеОкончаниеЭтапа;
			ТабличныйДокумент.Вывести(ПроизводимыеИзделияДетальныеЗаписи);
			НомерСпецификации = НомерСпецификации + 1;
			
		КонецЦикла;
		
		МатериалыШапкаТаблицы = Макет.ПолучитьОбласть("МатериалыШапкаТаблицы");
		ТабличныйДокумент.Вывести(МатериалыШапкаТаблицы);
		
		Для Каждого ЭлементСпецификафии Из ЭлементЗаказНаПроизводство.Строки Цикл
			Для Каждого ЭлементМатериала Из ЭлементСпецификафии.Строки Цикл 
				
				Если Не ЗначениеЗаполнено(ЭлементМатериала.Материал) Тогда
					Продолжить;
				КонецЕсли;
				МатериалыДетальныеЗаписи = Макет.ПолучитьОбласть("МатериалыДетальныеЗаписи");
				
				МатериалыДетальныеЗаписи.Параметры.Артикул = ЭлементМатериала.МатериалАртикул;
				МатериалыДетальныеЗаписи.Параметры.Материал = ЭлементМатериала.Материал;
				МатериалыДетальныеЗаписи.Параметры.Склад = ЭлементМатериала.Склад;
				МатериалыДетальныеЗаписи.Параметры.ЕдИзм = ЭлементМатериала.МатериалЕдиницаИзмерения;
				МатериалыДетальныеЗаписи.Параметры.Норматив = ЭлементМатериала.ПрименениеМатериала;
				МатериалыДетальныеЗаписи.Параметры.Получено = "";
				МатериалыДетальныеЗаписи.Параметры.Расход = "";
				МатериалыДетальныеЗаписи.Параметры.Возвращено = "";
				
				ТабличныйДокумент.Вывести(МатериалыДетальныеЗаписи);
				
			КонецЦикла;
		КонецЦикла;
			
		ВыходныеИзделияШапка = Макет.ПолучитьОбласть("ВыходныеИзделияШапка");
		ТабличныйДокумент.Вывести(ВыходныеИзделияШапка);
		
		Для Каждого ЭлементСпецификафии Из ЭлементЗаказНаПроизводство.Строки Цикл
			НомерСпецификации = 1;
			Для Каждого ЭлементМатериала Из ЭлементСпецификафии.Строки Цикл 
				
				ВыходныеИзделияДетальныеЗаписи = Макет.ПолучитьОбласть("ВыходныеИзделияДетальныеЗаписи");
				ВыходныеИзделияДетальныеЗаписи.Параметры.Номер = НомерСпецификации;
				ВыходныеИзделияДетальныеЗаписи.Параметры.Артикул = ЭлементМатериала.ИзделиеАртикул;
				ВыходныеИзделияДетальныеЗаписи.Параметры.Изделие = ЭлементМатериала.Изделие;
				ВыходныеИзделияДетальныеЗаписи.Параметры.Назначение = ЭлементМатериала.ИзделиеНазначение;
				ВыходныеИзделияДетальныеЗаписи.Параметры.ЕдИзм = ЭлементМатериала.ИзделиеЕдиницаИзмерения;
				ВыходныеИзделияДетальныеЗаписи.Параметры.Получатель = ЭлементМатериала.ИзделиеПолучатель;
				ВыходныеИзделияДетальныеЗаписи.Параметры.План = "";
				ВыходныеИзделияДетальныеЗаписи.Параметры.Факт = "";
				
				ТабличныйДокумент.Вывести(ВыходныеИзделияДетальныеЗаписи);
				НомерСпецификации = НомерСпецификации + 1;
			КонецЦикла;
		КонецЦикла;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;
	
КонецПроцедуры

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервере
Функция СформироватьДанныеДляЗаполнения(Параметры)
	
	СписокЗапросов = Новый СписокЗначений;
	СписокЗапросов.Добавить(ТекстЗапросаЭтаповНаПроизводство(),"ЗапросЗнП");
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивЭтапов",Параметры.МассивЭтапов);
	Запрос.УстановитьПараметр("МассивСтатей",Параметры.МассивМассивСтатейКалькуляции);
	Запрос.Текст = ТекстЗапросаЭтаповНаПроизводство();
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
КонецФункции

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервере
Функция ТекстЗапросаЭтаповНаПроизводство()
	Возврат "ВЫБРАТЬ
	|ЭтапПроизводства2_2.Распоряжение КАК ЗаказНаПроизводство,
	|ЭтапПроизводства2_2.Спецификация КАК Спецификация,
	|РесурсныеСпецификацииВыходныеИзделия.Номенклатура КАК Номенклатура,
	|РесурсныеСпецификацииВыходныеИзделия.Номенклатура.Артикул КАК НоменклатураАртикул,
	|РесурсныеСпецификацииВыходныеИзделия.Номенклатура.ЕдиницаИзмерения КАК НоменклатураЕдиницаИзмерения,
	|ЭтапПроизводства2_2.Запланировано КАК Запланировано,
	|ЭтапПроизводства2_2.Выполнено КАК Выполнено,
	|ЭтапПроизводства2_2.ФактическоеОкончаниеЭтапа КАК ФактическоеОкончаниеЭтапа,
	|ЭтапПроизводства2_2.Ссылка КАК Этап
	|ПОМЕСТИТЬ ВТ_Спецификации
	|ИЗ
	|Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства2_2
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РесурсныеСпецификации.ВыходныеИзделия КАК РесурсныеСпецификацииВыходныеИзделия
	|ПО ЭтапПроизводства2_2.Спецификация = РесурсныеСпецификацииВыходныеИзделия.Ссылка
	|ГДЕ
	|ЭтапПроизводства2_2.Ссылка В(&МассивЭтапов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|ВТ_Спецификации.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|ВТ_Спецификации.Спецификация КАК Спецификация,
	|ВТ_Спецификации.Номенклатура КАК Номенклатура,
	|ВТ_Спецификации.НоменклатураАртикул КАК НоменклатураАртикул,
	|ВТ_Спецификации.НоменклатураЕдиницаИзмерения КАК НоменклатураЕдиницаИзмерения,
	|ВТ_Спецификации.Запланировано КАК Запланировано,
	|ВТ_Спецификации.Выполнено КАК Выполнено,
	|ВТ_Спецификации.ФактическоеОкончаниеЭтапа КАК ФактическоеОкончаниеЭтапа,
	|ВТ_Спецификации.Этап КАК Этап,
	|ОбеспечениеМатериаламиИРаботами.Номенклатура КАК Материал,
	|ОбеспечениеМатериаламиИРаботами.Номенклатура.Артикул КАК МатериалАртикул,
	|ОбеспечениеМатериаламиИРаботами.Номенклатура.ЕдиницаИзмерения КАК МатериалЕдиницаИзмерения,
	|ОбеспечениеМатериаламиИРаботами.Склад КАК Склад,
	|ОбеспечениеМатериаламиИРаботами.ПрименениеМатериала КАК ПрименениеМатериала,
	|ВыходныеИзделия.Номенклатура КАК Изделие,
	|ВыходныеИзделия.Номенклатура.Артикул КАК ИзделиеАртикул,
	|ВыходныеИзделия.Назначение КАК ИзделиеНазначение,
	|ВыходныеИзделия.Получатель КАК ИзделиеПолучатель,
	|ВыходныеИзделия.Номенклатура.ЕдиницаИзмерения КАК ИзделиеЕдиницаИзмерения
	|ИЗ
	|ВТ_Спецификации КАК ВТ_Спецификации
	|ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЭтапПроизводства2_2.ОбеспечениеМатериаламиИРаботами КАК ОбеспечениеМатериаламиИРаботами
	|ПО ВТ_Спецификации.Этап = ОбеспечениеМатериаламиИРаботами.Ссылка И (ОбеспечениеМатериаламиИРаботами.СтатьяКалькуляции В (&МассивСтатей))
	|ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЭтапПроизводства2_2.ВыходныеИзделия КАК ВыходныеИзделия
	|ПО ВТ_Спецификации.Этап = ВыходныеИзделия.Ссылка
	|ИТОГИ
	|МАКСИМУМ(Номенклатура),
	|МАКСИМУМ(НоменклатураАртикул),
	|МАКСИМУМ(НоменклатураЕдиницаИзмерения),
	|МАКСИМУМ(Запланировано),
	|МАКСИМУМ(Выполнено),
	|МАКСИМУМ(ФактическоеОкончаниеЭтапа),
	|МАКСИМУМ(Этап)
	|ПО
	|ЗаказНаПроизводство,
	|Спецификация";
КонецФункции

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаКлиенте
Процедура ОтправитьПисьмо(Команда)
	ОтправитьПечатныеФормыПоПочте();
КонецПроцедуры

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаКлиенте
Процедура ОтправитьПечатныеФормыПоПочте()
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьПечатныеФормыПоПочтеНастройкаУчетнойЗаписиПредложена", ЭтотОбъект);
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		МодульРаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
	КонецЕсли;
КонецПроцедуры

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаКлиенте
Процедура ОтправитьПечатныеФормыПоПочтеНастройкаУчетнойЗаписиПредложена(УчетнаяЗаписьНастроена, ДополнительныеПараметры) Экспорт
	
	Если УчетнаяЗаписьНастроена <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ИмяОткрываемойФормы = "ОбщаяФорма.ВыборФорматаВложений";
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") 
		И СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИспользоватьПочтовыйКлиент Тогда
			//Если ПолучателейБольшеОдного(ПараметрыВывода.ПараметрыОтправки.Получатель) Тогда
			//	ПараметрыФормы.Вставить("Получатели", ПараметрыВывода.ПараметрыОтправки.Получатель);
			//	ИмяОткрываемойФормы = "ОбщаяФорма.ПодготовкаНовогоПисьма";
			//КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборФорматаВложений")
		Или ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ПодготовкаНовогоПисьма") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			ПараметрыОтправки = ПараметрыОтправкиПисьма(ВыбранноеЗначение);
			
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервере
Функция ПараметрыОтправкиПисьма(ВыбранныеПараметры)
	
	СписокВложений = ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранныеПараметры);
	
	// Контроль уникальности имен.
	ШаблонИмениФайла = "%1%2.%3";
	ИспользованныеИменаФайлов = Новый Соответствие;
	Для Каждого Вложение Из СписокВложений Цикл
		ИмяФайла = Вложение.Представление;
		НомерИспользования = ?(ИспользованныеИменаФайлов[ИмяФайла] <> Неопределено,
			ИспользованныеИменаФайлов[ИмяФайла] + 1, 1);
		ИспользованныеИменаФайлов.Вставить(ИмяФайла, НомерИспользования);
		Если НомерИспользования > 1 Тогда
			Файл = Новый Файл(ИмяФайла);
			ИмяФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениФайла,
				Файл.ИмяБезРасширения, " (" + НомерИспользования + ")", Файл.Расширение);
		КонецЕсли;
		Вложение.Представление = ИмяФайла;
	КонецЦикла;
	
	Получатели = ПараметрыВывода.ПараметрыОтправки.Получатель;
	Если ВыбранныеПараметры.Свойство("Получатели") Тогда
		Получатели = ВыбранныеПараметры.Получатели;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Получатель", Получатели);
	Результат.Вставить("Тема", ПараметрыВывода.ПараметрыОтправки.Тема);
	Результат.Вставить("Текст", ПараметрыВывода.ПараметрыОтправки.Текст);
	Результат.Вставить("Вложения", СписокВложений);
	Результат.Вставить("УдалятьФайлыПослеОтправки", Истина);
	
	//Если ОбъектыПечати.Количество() = 1 И ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ОбъектыПечати[0].Значение)) Тогда
	//	Результат.Вставить("Предмет", ОбъектыПечати[0].Значение);
	//КонецЕсли;
		
	
	ПечатныеФормы = Новый ТаблицаЗначений;
	ПечатныеФормы.Колонки.Добавить("Название");
	ПечатныеФормы.Колонки.Добавить("ТабличныйДокумент");
	
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		Если Не НастройкаПечатнойФормы.Печатать Тогда
			Продолжить;
		КонецЕсли;
		
		ТабличныйДокумент = ЭтотОбъект[НастройкаПечатнойФормы.ИмяРеквизита];
		Если ПечатныеФормы.НайтиСтроки(Новый Структура("ТабличныйДокумент", ТабличныйДокумент)).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВычислитьИспользованиеВывода(ТабличныйДокумент) = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТабличныйДокумент.Защита Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТабличныйДокумент.ВысотаТаблицы = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеПечатнойФормы = ПечатныеФормы.Добавить();
		ОписаниеПечатнойФормы.Название = НастройкаПечатнойФормы.Название;
		ОписаниеПечатнойФормы.ТабличныйДокумент = ТабличныйДокумент;
	КонецЦикла;
	
	СписокОбъектов = МассивЗаказов.Выгрузить(,"ЗаказНаПроизводство");
	Если ОбщегоНазначения.ЗначениеСсылочногоТипа(МассивЗаказов.Выгрузить(,"ЗаказНаПроизводство")) Тогда
		СписокОбъектов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(МассивЗаказов.Выгрузить(,"ЗаказНаПроизводство"));
	КонецЕсли;
	
	ИнтеграцияПодсистемБСП.ПередОтправкойПоПочте(Результат, ПараметрыВывода, СписокОбъектов, ПечатныеФормы);
	УправлениеПечатьюПереопределяемый.ПередОтправкойПоПочте(Результат, ПараметрыВывода, СписокОбъектов, ПечатныеФормы);
	
	Возврат Результат;
	
КонецФункции

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервере
Функция ПоместитьТабличныеДокументыВоВременноеХранилище(ПереданныеНастройки)
	Перем ЗаписьZipФайла, ИмяАрхива;
	
	НастройкиСохранения = НастройкиСохранения();
	ЗаполнитьЗначенияСвойств(НастройкиСохранения, ПереданныеНастройки);
	
	Результат = Новый Массив;
	
	// подготовка архива
	Если НастройкиСохранения.УпаковатьВАрхив Тогда
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ЗаписьZipФайла = Новый ЗаписьZipФайла(ИмяАрхива);
	КонецЕсли;
	
	ИмяВременногоКаталога = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременногоКаталога);
	
	ВыбранныеФорматыСохранения = НастройкиСохранения.ФорматыСохранения;
	ПереводитьИменаФайловВТранслит = НастройкиСохранения.ПереводитьИменаФайловВТранслит;
	ТаблицаФорматов = УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента();
	
	// сохранение печатных форм
	ОбработанныеПечатныеФормы = Новый Массив;
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		
		Если НЕ ПустаяСтрока(НастройкаПечатнойФормы.ОфисныеДокументы) Тогда
			
			ФайлыОфисныхДокументов = ОбщегоНазначения.ЗначениеИзСтрокиXML(НастройкаПечатнойФормы.ОфисныеДокументы);
			
			Для Каждого ФайлОфисногоДокумента Из ФайлыОфисныхДокументов Цикл
				ИмяФайла = УправлениеПечатью.ИмяФайлаОфисногоДокумента(ФайлОфисногоДокумента.Значение);
				Если ЗаписьZipФайла <> Неопределено Тогда 
					ПолноеИмяФайла = УникальноеИмяФайла(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременногоКаталога) 
						+ ИмяФайла);
					ДвоичныеДанные = ПолучитьИзВременногоХранилища(ФайлОфисногоДокумента.Ключ); // ДвоичныеДанные - 
					ДвоичныеДанные.Записать(ПолноеИмяФайла);
					ЗаписьZipФайла.Добавить(ПолноеИмяФайла);
				Иначе
					ОписаниеФайла = Новый Структура;
					ОписаниеФайла.Вставить("Представление", ИмяФайла);
					ОписаниеФайла.Вставить("АдресВоВременномХранилище", ФайлОфисногоДокумента.Ключ);
					ОписаниеФайла.Вставить("ЭтоОфисныйДокумент", Истина);
					Результат.Добавить(ОписаниеФайла);
				КонецЕсли;
				
			КонецЦикла;
			
			Продолжить;
			
		КонецЕсли;
		
		Если Не НастройкаПечатнойФормы.Печатать Тогда
			Продолжить;
		КонецЕсли;
		
		ПечатнаяФорма = ЭтотОбъект[НастройкаПечатнойФормы.ИмяРеквизита];
		Если ОбработанныеПечатныеФормы.Найти(ПечатнаяФорма) = Неопределено Тогда
			ОбработанныеПечатныеФормы.Добавить(ПечатнаяФорма);
		Иначе
			Продолжить;
		КонецЕсли;
		
		Если ВычислитьИспользованиеВывода(ПечатнаяФорма) = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПечатнаяФорма.Защита Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПечатнаяФорма.ВысотаТаблицы = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ПечатныеФормыПоОбъектам = УправлениеПечатью.ПечатныеФормыПоОбъектам(ПечатнаяФорма, ОбъектыПечати);
		Для Каждого СоответствиеОбъектаПечатнойФорме Из ПечатныеФормыПоОбъектам Цикл
			ОбъектПечати = СоответствиеОбъектаПечатнойФорме.Ключ;
			ПечатнаяФорма = СоответствиеОбъектаПечатнойФорме.Значение;
			
			Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
				ТипФайла = ТипФайлаТабличногоДокумента[ВыбранныйФормат];
				НастройкиФормата = ТаблицаФорматов.НайтиСтроки(Новый Структура("ТипФайлаТабличногоДокумента", ТипФайла))[0];
				ЗаданныеИменаПечатныхФорм = ОбщегоНазначения.ЗначениеИзСтрокиXML(НастройкаПечатнойФормы.ИмяФайлаПечатнойФормы);
				
				ИмяФайла = УправлениеПечатью.ИмяФайлаПечатнойФормыОбъекта(ОбъектПечати, ЗаданныеИменаПечатныхФорм, НастройкаПечатнойФормы.Название);
				ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла);
				ИмяФайла = "Сводное задание на производство";
				Если ПереводитьИменаФайловВТранслит Тогда
					ИмяФайла = СтроковыеФункции.СтрокаЛатиницей(ИмяФайла);
				КонецЕсли;
				
				ИмяФайла = ИмяФайла + "." + НастройкиФормата.Расширение;
				
				ПолноеИмяФайла = УникальноеИмяФайла(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременногоКаталога) + ИмяФайла);
				ПечатнаяФорма.Записать(ПолноеИмяФайла, ТипФайла);
				
				Если ТипФайла = ТипФайлаТабличногоДокумента.HTML Тогда
					УправлениеПечатью.ВставитьКартинкиВHTML(ПолноеИмяФайла);
				КонецЕсли;
				
				Если ЗаписьZipФайла <> Неопределено Тогда 
					ЗаписьZipФайла.Добавить(ПолноеИмяФайла);
				Иначе
					ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
					ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификаторХранилища);
					ОписаниеФайла = Новый Структура;
					ОписаниеФайла.Вставить("Представление", ИмяФайла);
					ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
					Если ТипФайла = ТипФайлаТабличногоДокумента.ANSITXT Тогда
						ОписаниеФайла.Вставить("Кодировка", "windows-1251");
					КонецЕсли;
					Результат.Добавить(ОписаниеФайла);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	МассивСсылокПрисоединенныхФайлов = СформироватьМассивПрисоединенныхФайлов();
	
	Если МассивСсылокПрисоединенныхФайлов <> Неопределено Тогда
		
		Для Каждого ПрисоединенныйФайл Из МассивСсылокПрисоединенныхФайлов Цикл 
			
			ЗначениеФайла = РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл.Ссылка);
			ДвоичныеДанныеФайл = РаботаСФайлами.ДвоичныеДанныеФайла(ПрисоединенныйФайл.Ссылка);
			Если ЗаписьZipФайла <> Неопределено Тогда 
				
				ПолноеИмяПрисоедФайла = УникальноеИмяФайла(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременногоКаталога) + ЗначениеФайла.ИмяФайла);
				ДвоичныеДанныеФайл.Записать(ПолноеИмяПрисоедФайла);

				ЗаписьZipФайла.Добавить(ПолноеИмяПрисоедФайла);
			Иначе
				ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайл, УникальныйИдентификаторХранилища);
				ОписаниеФайла = Новый Структура;
				ОписаниеФайла.Вставить("Представление", ЗначениеФайла.ИмяФайла);
				ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
				Результат.Добавить(ОписаниеФайла);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Если архив подготовлен, записываем и помещаем его во временное хранилище.
	Если ЗаписьZipФайла <> Неопределено Тогда 
		ЗаписьZipФайла.Записать();
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяАрхива);
		ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификаторХранилища);
		ОписаниеФайла = Новый Структура;
		ОписаниеФайла.Вставить("Представление", ПолучитьИмяФайлаДляАрхива(ПереводитьИменаФайловВТранслит));
		ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
		Результат.Добавить(ОписаниеФайла);
	КонецЕсли;
	
	УдалитьФайлы(ИмяВременногоКаталога);
	Если ЗначениеЗаполнено(ИмяАрхива) Тогда
		УдалитьФайлы(ИмяАрхива);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаКлиентеНаСервереБезКонтекста
Функция УникальноеИмяФайла(ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	ИмяБезРасширения = Файл.ИмяБезРасширения;
	Расширение = Файл.Расширение;
	ИмяКаталога = Файл.Путь;
	
	Счетчик = 1;
	Пока Файл.Существует() Цикл
		Счетчик = Счетчик + 1;
		Файл = Новый Файл(ИмяКаталога + ИмяБезРасширения + " (" + Счетчик + ")" + Расширение);
	КонецЦикла;
	
	Возврат Файл.ПолноеИмя;

КонецФункции

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервереБезКонтекста
Функция НастройкиСохранения()

	Возврат УправлениеПечатью.НастройкиСохранения();

КонецФункции

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервере
Функция ПолучитьИмяФайлаДляАрхива(ПереводитьИменаФайловВТранслит)
	
	Результат = "";
	
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		
		Если Не НастройкаПечатнойФормы.Печатать Тогда
			Продолжить;
		КонецЕсли;
		
		ПечатнаяФорма = ЭтотОбъект[НастройкаПечатнойФормы.ИмяРеквизита];
		
		Если ВычислитьИспользованиеВывода(ПечатнаяФорма) = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПустаяСтрока(Результат) Тогда
			Результат = НастройкаПечатнойФормы.Название;
		Иначе
			Результат = НСтр("ru = 'Документы';
							|en = 'Documents'");
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПереводитьИменаФайловВТранслит Тогда
		Результат = СтроковыеФункции.СтрокаЛатиницей(Результат);
	КонецЕсли;
	
	Возврат Результат + ".zip";
	
КонецФункции

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервере
Функция ВычислитьИспользованиеВывода(ТабличныйДокумент)
	Если ТабличныйДокумент.Вывод = ИспользованиеВывода.Авто Тогда
		Возврат ?(ПравоДоступа("Вывод", Метаданные), ИспользованиеВывода.Разрешить, ИспользованиеВывода.Запретить);
	Иначе
		Возврат ТабличныйДокумент.Вывод;
	КонецЕсли;
КонецФункции

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервере
Функция СформироватьМассивПрисоединенныхФайлов()
	
	ПараметрыЗапроса = Новый Структура;
	МассивВладельцев = Новый Массив;
	Для Каждого ЭлементТаблицы Из ТаблицаЭтапов Цикл 
		МассивВладельцев.Добавить(ЭлементТаблицы.Этап.Спецификация);
	КонецЦикла;
	
	ПараметрыЗапроса.Вставить("МассивВладельцев",МассивВладельцев);
	
	ТаблицаДанных = ОбщегоНазначенияУТ.ЗапросВыполнитьВыгрузить(ТекстЗапроса_ПрисоединенныхФайлов(),ПараметрыЗапроса);
	
	Если Не ЗначениеЗаполнено(ТаблицаДанных) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ТаблицаДанных;
	
КонецФункции

// + [Rineco], [Киселев А.] [23.12.2021] [Log_Diff][№ 24459], [#СводноеЗадание]
&НаСервере
Функция ТекстЗапроса_ПрисоединенныхФайлов()
	Возврат "ВЫБРАТЬ
	|РесурсныеСпецификацииПрисоединенныеФайлы.Ссылка КАК Ссылка
	|ИЗ
	|Справочник.РесурсныеСпецификацииПрисоединенныеФайлы КАК РесурсныеСпецификацииПрисоединенныеФайлы
	|ГДЕ
	|РесурсныеСпецификацииПрисоединенныеФайлы.ВладелецФайла В (&МассивВладельцев)";
КонецФункции