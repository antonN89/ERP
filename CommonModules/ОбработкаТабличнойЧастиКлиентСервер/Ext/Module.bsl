﻿// + [Rineco], [Киселев А.Н.] [22.09.2021] 
// Задача: [№ 1385], [#Расчет цены со скидкой]
Процедура ПересчитатьЦенуСоСкидкой(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт

	Если СтруктураДействий.Свойство("РИНЭКО_ПересчитатьЦенуСоСкидкой") Тогда
		Если ТекущаяСтрока <> Неопределено Тогда
			ТекущаяСтрока.ЦенаСоСкидкой = ТекущаяСтрока.Сумма /ТекущаяСтрока.КоличествоУпаковок;
			ТекущаяСтрока.Сумма = ТекущаяСтрока.ЦенаСоСкидкой * ТекущаяСтрока.КоличествоУпаковок;
			ТекущаяСтрока.СуммаРучнойСкидки = ТекущаяСтрока.Цена*ТекущаяСтрока.КоличествоУпаковок - ТекущаяСтрока.Сумма - ТекущаяСтрока.СуммаАвтоматическойСкидки;
			ТекущаяСтрока.ПроцентРучнойСкидки =  ТекущаяСтрока.СуммаРучнойСкидки*100/(ТекущаяСтрока.Цена*ТекущаяСтрока.КоличествоУпаковок); 
			ТекущаяСтрока.СуммаПроцентОбщий = ТекущаяСтрока.СуммаРучнойСкидки + ТекущаяСтрока.СуммаАвтоматическойСкидки; 
			ТекущаяСтрока.ПроцентОбщий = ТекущаяСтрока.ПроцентРучнойСкидки + ТекущаяСтрока.ПроцентАвтоматическойСкидки;
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры