﻿
&НаКлиенте
Процедура Перенести(Команда)
	
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатураПроизводителейНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.Копирование;
	ПолучитьДанныеПеретаскивания(ЭтаФорма, Элемент, ПараметрыПеретаскивания);
КонецПроцедуры

&НаКлиенте
Процедура КорзинаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	ПеретащитьВКорзинуНаСервере(ПараметрыПеретаскивания.Значение);
КонецПроцедуры

&НаСервере
Процедура ПеретащитьВКорзинуНаСервере(Данные)
	
	НовыеСтроки = Новый Массив;
	Для Каждого ПараметрыТовара Из Данные Цикл
		НовыеСтроки.Добавить(ПараметрыТовара);
	КонецЦикла;
	
	Для Каждого НоваяСтрока Из НовыеСтроки Цикл
		
		Если НоваяСтрока.Упаковка.Пустая() Тогда 
			НоваяСтрока.Упаковка = ПодборТоваровВызовСервера.ПолучитьУпаковкуХранения(НоваяСтрока.Номенклатура);
		КонецЕсли;
		
		Отбор = Новый Структура;
		Отбор.Вставить("Артикул",                    НоваяСтрока.Артикул);
		Отбор.Вставить("Номенклатура",               НоваяСтрока.Номенклатура);
		Отбор.Вставить("Характеристика",             НоваяСтрока.Характеристика);
		Отбор.Вставить("ЕдиницаИзмерения",           НоваяСтрока.ЕдиницаИзмерения);
				
		РезультатПоиска = Объект.Корзина.НайтиСтроки(Отбор);
		
		Если РезультатПоиска.Количество() = 0 ИЛИ НоваяСтрока.Погрешность <> 0 Тогда
			ТекущаяСтрока = Объект.Корзина.Добавить();
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Отбор);
			ТекущаяСтрока.Количество = 1;
		Иначе
			ТекущаяСтрока = РезультатПоиска[0];
		КонецЕсли;                           
		
		ПараметрыСтроки = Новый Структура("Артикул, Номенклатура, Характеристика, ЕдиницаИзмерения");
		ЗаполнитьЗначенияСвойств(ПараметрыСтроки, ТекущаяСтрока);
				
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ПараметрыСтроки);
				
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КодФормы = "Обработка_Рин1_ПодборТоваровВВариантРасчета_Форма";
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеПеретаскивания(Форма, Элемент, ПараметрыПеретаскивания)
	
	МассивПараметров = Новый Массив; 
			
	Для каждого КлючСтроки Из ПараметрыПеретаскивания.Значение Цикл
		
		ДанныеСтроки = Элемент.ДанныеСтроки(КлючСтроки);
		
		Если ДанныеСтроки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыТовара = ПодборТоваровКлиентСервер.ПараметрыТовара();
		
		ЗаполнитьЗначенияСвойств(ПараметрыТовара, ДанныеСтроки);
		
		МассивПараметров.Добавить(ПараметрыТовара);
		
	КонецЦикла;
	
	ПараметрыПеретаскивания.Значение = МассивПараметров;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатураПроизводителейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицыНоменклатуры = ЭтаФорма.Элементы.СписокНоменклатураПроизводителей.ТекущиеДанные;
	ТекущаяСтрока = Объект.Корзина.Добавить();
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТаблицыНоменклатуры);
	ТекущаяСтрока.Количество = 1;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	АдресТоваровВХранилище = АдресТоваровВХранилище(ЭтаФорма.ВладелецФормы.УникальныйИдентификатор);
	Структура = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище);
	ОповеститьОВыборе(Структура);
	
КонецПроцедуры

&НаСервере
Функция АдресТоваровВХранилище(УникальныйИдентификаторВладельца)
	
	АдресВХранилище = Неопределено;
	Товары = Объект.Корзина.Выгрузить();
	АдресВХранилище = ПоместитьВоВременноеХранилище(Товары, УникальныйИдентификаторВладельца);
	
	Возврат АдресВХранилище;
	
КонецФункции

&НаКлиенте
Процедура КорзинаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ЭтаФорма.Элементы.Корзина.ТекущиеДанные.Номенклатура) = Тип("СправочникСсылка.ГИГ_НоменклатураПроизводителей") Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
		
КонецПроцедуры
