
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Заполнение списка валют из КВ.
	ЗакрыватьПриВыборе = Ложь;
	ЗаполнитьТаблицуВалют();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВалют

&НаКлиенте
Процедура СписокВалютВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборВСпискеВалют(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	ОбработатьВыборВСпискеВалют();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуВалют()
	
	// Заполняет список валют из макета КВ.
	
	КлассификаторXML = Обработки.ЗагрузкаКурсовВалют.ПолучитьМакет("КлассификаторВалют").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого ЗаписьКВ Из КлассификаторТаблица Цикл
		НоваяСтрока = Валюты.Добавить();
		НоваяСтрока.КодВалютыЦифровой         		= ЗаписьКВ.Code;
		НоваяСтрока.КодВалютыБуквенный        		= ЗаписьКВ.CodeSymbol;
		НоваяСтрока.Наименование              		= ЗаписьКВ.Name;
		НоваяСтрока.Загружается               		= ЗаписьКВ.FinanceLoading;
		НоваяСтрока.ПараметрыПрописиНаРусском 		= ЗаписьКВ.RusNumerationItemOptions;
		НоваяСтрока.ПараметрыПрописиНаУкраинском 	= ЗаписьКВ.UkrNumerationItemOptions;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки, ЕстьКурсы)
	
	ЕстьКурсы = Ложь;
	ТекущаяСсылка = Неопределено;
	
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = Валюты[НомерСтроки];
		
		СтрокаВБазе = Справочники.Валюты.НайтиПоКоду(ТекущиеДанные.КодВалютыЦифровой);
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Если НомерСтроки = Элементы.СписокВалют.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
				ТекущаяСсылка = СтрокаВБазе;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Справочники.Валюты.СоздатьЭлемент();
		НоваяСтрока.Код                       = ТекущиеДанные.КодВалютыЦифровой;
		НоваяСтрока.Наименование              = ТекущиеДанные.КодВалютыБуквенный;
		НоваяСтрока.НаименованиеПолное        = ТекущиеДанные.Наименование;
		Если ТекущиеДанные.Загружается Тогда
			НоваяСтрока.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
		Иначе
			НоваяСтрока.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
		КонецЕсли;
		НоваяСтрока.ПараметрыПрописиНаРусском 	 = ТекущиеДанные.ПараметрыПрописиНаРусском;
		НоваяСтрока.ПараметрыПрописиНаУкраинском = ТекущиеДанные.ПараметрыПрописиНаУкраинском;
		НоваяСтрока.Записать();
		
		Если НомерСтроки = Элементы.СписокВалют.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
			ТекущаяСсылка = НоваяСтрока.Ссылка;
		КонецЕсли;
		
		Если ТекущиеДанные.Загружается Тогда 
			ЕстьКурсы = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТекущаяСсылка;

КонецФункции

&НаКлиенте
Процедура ОбработатьВыборВСпискеВалют(СтандартнаяОбработка = Неопределено)
	Перем ЕстьКурсы;
	
	// Добавление элемента справочника и вывод результата пользователю.
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСсылка = СохранитьВыбранныеСтроки(Элементы.СписокВалют.ВыделенныеСтроки, ЕстьКурсы);
	
	ОповеститьОВыборе(ТекущаяСсылка);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Валюты добавлены.';uk='Валюти додані.'"), ,
		?(СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().РазделениеВключено И ЕстьКурсы, 
			НСтр("ru='Курсы будут загружены автоматически через непродолжительное время.';uk='Курси будуть завантажені автоматично через нетривалий час.'"), ""),
		БиблиотекаКартинок.Информация32);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
