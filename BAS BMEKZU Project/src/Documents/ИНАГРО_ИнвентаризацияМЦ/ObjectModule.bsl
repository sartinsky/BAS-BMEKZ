#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры 

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
		
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУчет");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	
	Для каждого Строка Из Товары Цикл
		
		Префикс = "Товары[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		ИмяСписка = НСтр("ru='Товары';uk='Товари'");
		
		Если Строка.Количество = 0 И Строка.КоличествоУчет = 0 Тогда
			
			ИмяПоля = НСтр("ru='Количество';uk='Кількість'");
			Поле = Префикс + "Количество";
			
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Колонка", "Заполнение", 
				ИмяПоля, Строка.НомерСтроки, ИмяСписка, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
			ИмяПоля = НСтр("ru='Количество учетное';uk='Кількість облікова'");
			Поле = Префикс + "КоличествоУчет";
			
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения("Колонка", "Заполнение", 
				ИмяПоля, Строка.НомерСтроки, ИмяСписка, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			
		КонецЕсли;
	
	КонецЦикла;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры 

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата 		  = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры 

#КонецОбласти 

#КонецЕсли



