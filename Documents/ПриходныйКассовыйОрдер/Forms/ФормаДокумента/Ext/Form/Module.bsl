﻿// + [Rineco], [Киселев А.Н.] [15.11.2021] 
// Задача: [№ 22721], [#Подстановка  подразделения]
&НаКлиенте
Процедура Рин1_ПодотчетноеЛицоПриИзмененииПосле(Элемент)
	
	Если Объект.ХозяйственнаяОперация = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПодотчетника") Тогда
		РИНЭКО_ПодразделениеПоФизЛицу.УстановитьПодразделениеСервер(Объект.ПодотчетноеЛицо,Объект.Подразделение,?(ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(Объект.Касса,"Владелец").Владелец = Неопределено,ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.Кассы.ПустаяССылка"),ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(Объект.Касса,"Владелец").Владелец));
		
	КонецЕсли;
	
КонецПроцедуры
