﻿// + [Rineco], [Киселев А.] [22.07.2021] 
// Задача: [№ 12835], [#Выбор периода]

&НаКлиенте 
Процедура ВыбратьПериод(Команда) 
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();                                  
    Диалог.Период = Новый СтандартныйПериод(Отчет.ДатаНачала, Отчет.ДатаОкончания);         
    ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ВыполнитьПослеВыбораПериода",ЭтотОбъект); 
    Диалог.Показать(ОписаниеОповещенияОЗакрытии); 	 
КонецПроцедуры 

&НаКлиенте 
Процедура ВыполнитьПослеВыбораПериода(Результат, Параметры) Экспорт 
    Если Результат <> Неопределено Тогда 
        Отчет.ДатаНачала = Результат.ДатаНачала; 
        Отчет.ДатаОкончания = Результат.ДатаОкончания; 
    КонецЕсли;     
КонецПроцедуры 

// - [Rineco], [Киселев А.] [22.07.2021]


// + [Rineco], [Киселев А.] [22.07.2021] 
// Задача: [№ 12835], [#Заполнение параметров]
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПараметрКоманды") И ТипЗнч(Параметры.ПараметрКоманды) = Тип("СправочникСсылка.Номенклатура") Тогда
												 
		Отчет.Номенклатура = Параметры.ПараметрКоманды;
											 	
	КонецЕсли;
		
	Отчет.ДатаНачала = НачалоМесяца(ТекущаяДатаСеанса());
	Отчет.ДатаОкончания = КонецМесяца(ТекущаяДатаСеанса());
	
КонецПроцедуры
// - [Rineco], [Киселев А.] [22.07.2021]


