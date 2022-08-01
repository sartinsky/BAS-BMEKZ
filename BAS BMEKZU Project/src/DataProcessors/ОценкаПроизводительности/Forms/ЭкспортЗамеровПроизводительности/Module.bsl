
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ОценкаПроизводительностиСлужебный.ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность") Тогда
		ЭтотОбъект.Элементы.КаталогЭкспорта.КнопкаВыбора = Ложь;
		ЕстьБСП = Ложь;
	Иначе
		ЕстьБСП = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбратьКаталогЭкспортаПредложено(РасширениеРаботыСФайламиПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеРаботыСФайламиПодключено Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ВыборФайла.МножественныйВыбор = Ложь;
		ВыборФайла.Заголовок = НСтр("ru='Выбор каталога экспорта';uk='Вибір каталогу експорту'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогВыбораКаталогаЗавершение", ЭтотОбъект, Неопределено);
		ВыборФайла.Показать(ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЭкспортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЕстьБСП Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКаталогЭкспортаПредложено", ЭтотОбъект);
		МодульОбщегоНазначения = Вычислить("ОбщегоНазначенияКлиент");
		Если ТипЗнч(МодульОбщегоНазначения) = Тип("ОбщийМодуль") Тогда
			МодульОбщегоНазначения.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЭкспорт(Команда)
    
    ЕстьОшибки = Ложь;
    
    Если НЕ ЗначениеЗаполнено(ДатаНачалаПериодаЭкспорта) Тогда
        
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Поле = "ДатаНачалаПериодаЭкспорта";
        СообщениеПользователю.Текст = НСтр("ru='Значение параметра ""Дата начала"" не заполнено.
            |Экспорт невозможен.'
            |;uk='Значення параметра ""Дата початку"" не заповнено.
            |Експорт неможливий.'");
        СообщениеПользователю.Сообщить();
        
        ЕстьОшибки = Истина;
        
    КонецЕсли;
    
    Если НЕ ЗначениеЗаполнено(ДатаОкончанияПериодаЭкспорта) Тогда
        
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Поле = "ДатаОкончанияПериодаЭкспорта";
        СообщениеПользователю.Текст = НСтр("ru='Значение параметра ""Дата окончания"" не заполнено.
            |Экспорт невозможен.'
            |;uk='Значення параметра ""Дата закінчення"" не заповнено.
            |Експорт неможливий.'");
        СообщениеПользователю.Сообщить();
        
        ЕстьОшибки = Истина;
        
    КонецЕсли;
    
    Если НЕ ЗначениеЗаполнено(КаталогЭкспорта) Тогда
        
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Поле = "КаталогЭкспорта";
        СообщениеПользователю.Текст = НСтр("ru='Значение параметра ""Каталог экспорта"" не заполнено.
            |Экспорт невозможен.'
            |;uk='Значення параметра ""Каталог експорту"" не заповнено.
            |Експорт неможливий.'");
        СообщениеПользователю.Сообщить();
        
        ЕстьОшибки = Истина;
        
    КонецЕсли;
    
     Если НЕ ЗначениеЗаполнено(ИмяАрхива) Тогда
        
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Поле = "ИмяАрхива";
        СообщениеПользователю.Текст = НСтр("ru='Значение параметра ""Имя архива"" не заполнено.
            |Экспорт невозможен.'
            |;uk='Значення параметра ""Ім''я архіву"" не заповнено.
            |Експорт неможливий.'");
        СообщениеПользователю.Сообщить();
        
        ЕстьОшибки = Истина;
        
    КонецЕсли;
        
    Если ЗначениеЗаполнено(ДатаНачалаПериодаЭкспорта) И ЗначениеЗаполнено(ДатаОкончанияПериодаЭкспорта) И ДатаНачалаПериодаЭкспорта >= ДатаОкончанияПериодаЭкспорта Тогда
        
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Поле = "ДатаНачалаПериодаЭкспорта";
        СообщениеПользователю.Текст = НСтр("ru='Значение параметра ""Дата начала"" больше или равно значения параметры ""Дата окончания"".
            |Экспорт невозможен.'
            |;uk='Значення параметра ""Дата початку"" більше або дорівнює значенню параметру ""Дата закінчення"".
            |Експорт неможливий.'");
        СообщениеПользователю.Сообщить();
        
        ЕстьОшибки = Истина;
        
    КонецЕсли;
    
    Если ЕстьОшибки Тогда
        Возврат;
    КонецЕсли;
            
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыЭкспорта = Новый Структура;
	ПараметрыЭкспорта.Вставить("ДатаНачала", ЭтотОбъект.ДатаНачалаПериодаЭкспорта);
	ПараметрыЭкспорта.Вставить("ДатаОкончания", ЭтотОбъект.ДатаОкончанияПериодаЭкспорта);
	ПараметрыЭкспорта.Вставить("АдресХранилища", АдресХранилища);
	ПараметрыЭкспорта.Вставить("Профиль", Профиль);
	ВыполнитьЭкспортНаСервере(ПараметрыЭкспорта);
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
	УдалитьИзВременногоХранилища(АдресХранилища);
    
    Если ДвоичныеДанные <> Неопределено Тогда
        ДвоичныеДанные.Записать(ЭтотОбъект.КаталогЭкспорта + ПолучитьРазделительПутиКлиента() + ЭтотОбъект.ИмяАрхива + ".zip");
    Иначе
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Текст = НСтр("ru='За указанный период нет замеров. Файл архива не сформирован.';uk='За вказаний період немає замірів. Файл архіву не сформований.'") + Символы.ПС;
        СообщениеПользователю.Сообщить();
    КонецЕсли;
    	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ВыполнитьЭкспортНаСервере(Параметры)
	ОценкаПроизводительности.ЭкспортОценкиПроизводительности(Неопределено, Параметры);	
КонецПроцедуры

&НаКлиенте
Процедура ДиалогВыбораКаталогаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
    
    Если ВыбранныеФайлы <> Неопределено Тогда
		ЭтотОбъект.КаталогЭкспорта = ВыбранныеФайлы[0];
	КонецЕсли;
		
КонецПроцедуры


#КонецОбласти