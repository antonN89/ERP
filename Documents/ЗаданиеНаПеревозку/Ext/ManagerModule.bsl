﻿
// + [Rineco], [Киселев А.Н.] [08.10.2021] 
// Задача: [№ 19055], [#Статусы поручения экспедитору]
Функция СформироватьСоответствиеСтатусов() Экспорт
	
	СоответствиеСтатусов = Новый Соответствие();
	
	СоответствиеСтатусов.Вставить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Перечисление.СтатусыЗаданийНаПеревозку.Формируется"),Перечисления.РИНЭКО_СтатусыПорученияЭкспедитору.ВПроцессе);	
	СоответствиеСтатусов.Вставить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Перечисление.СтатусыЗаданийНаПеревозку.Отправлено"),Перечисления.РИНЭКО_СтатусыПорученияЭкспедитору.Отправлено);	
	СоответствиеСтатусов.Вставить(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Перечисление.СтатусыЗаданийНаПеревозку.Закрыто"),Перечисления.РИНЭКО_СтатусыПорученияЭкспедитору.Получено);	
	Возврат СоответствиеСтатусов;
	
КонецФункции
