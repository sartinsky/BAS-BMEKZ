
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьПрофильКлючевыхОпераций(Команда)
    
    ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
    ДиалогВыбора.Заголовок = НСтр("ru='Выберите файл профиля ключевых операций';uk='Виберіть файл профілю ключових операцій'");
    ДиалогВыбора.Фильтр = "Файлы профиля ключевых операций (*.xml)|*.xml";
    
	ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогВыбораФайлаЗавершение", ЭтотОбъект, Неопределено);
	ДиалогВыбора.Показать(ОписаниеОповещения);
        
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПрофильКлючевыхОпераций(Команда)
    
    ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
    ДиалогВыбора.Заголовок = НСтр("ru='Сохранить профиль ключевых операций в файл';uk='Зберегти профіль ключових операцій у файл'");
    ДиалогВыбора.Фильтр = "Файлы профиля ключевых операций (*.xml)|*.xml";
    
    ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогСохраненияФайлаЗавершение", ЭтотОбъект, Неопределено);
	ДиалогВыбора.Показать(ОписаниеОповещения);
    
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДиалогВыбораФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
    
    Если ВыбранныеФайлы <> Неопределено Тогда
        
        Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
            ФайлИмя = Новый Файл(ВыбранныеФайлы[0]);
            Объект.Наименование = ФайлИмя.ИмяБезРасширения;
        КонецЕсли;
                
        ДвоичныеДанные = Новый ДвоичныеДанные(ВыбранныеФайлы[0]);
        АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
        ЗагрузитьПрофильКлючевыхОперацийНаСервере(АдресХранилища);
		Модифицированность = Истина;
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ДиалогСохраненияФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
    
    Если ВыбранныеФайлы <> Неопределено Тогда
        АдресХранилища = СохранитьПрофильКлючевыхОперацийНаСервере();    
        ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
        ДвоичныеДанные.Записать(ВыбранныеФайлы[0]);
    КонецЕсли;
    
КонецПроцедуры

&НаСервере
Функция СохранитьПрофильКлючевыхОперацийНаСервере()
    
    ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
    
    ЗаписьXML = Новый ЗаписьXML;
    ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла);
    
    ЗаписьXML.ЗаписатьНачалоЭлемента("Items");
    ЗаписьXML.ЗаписатьАтрибут("Description", Объект.Наименование);
    ЗаписьXML.ЗаписатьАтрибут("Columns", "Имя,ЦелевоеВремя,Важность");
    
    Для Каждого ТекСтрока Из Объект.КлючевыеОперацииПрофиля Цикл
        ЗаписьXML.ЗаписатьНачалоЭлемента("Item");
        ЗаписьXML.ЗаписатьАтрибут("Имя", ТекСтрока.КлючеваяОперация.Имя);
        ЗаписьXML.ЗаписатьАтрибут("ЦелевоеВремя", Формат(ТекСтрока.ЦелевоеВремя, "ЧГ=0"));
        ЗаписьXML.ЗаписатьАтрибут("Важность", Формат(ТекСтрока.Приоритет, "ЧГ=0"));
        ЗаписьXML.ЗаписатьКонецЭлемента();
    КонецЦикла;
        
    ЗаписьXML.ЗаписатьКонецЭлемента();
    
    ЗаписьXML.Закрыть();
    
    ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
    АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
    
    УдалитьФайлы(ИмяВременногоФайла);
    
    Возврат АдресХранилища;
    
КонецФункции

&НаСервере
Функция ЗагрузитьПрофильКлючевыхОперацийНаСервере(АдресХранилища)
    
    ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
        
    ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
    ДвоичныеДанные.Записать(ИмяВременногоФайла);
    
    ЧтениеXML = Новый ЧтениеXML;
    ЧтениеXML.ОткрытьФайл(ИмяВременногоФайла);
    КлючевыеОперации = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
    
    Колонки = СтрРазделить(КлючевыеОперации["Columns"], ",",Ложь);
    Если КлючевыеОперации.Свойства().Получить("Item") <> Неопределено Тогда
	    Если ТипЗнч(КлючевыеОперации["Item"]) = Тип("ОбъектXDTO") Тогда
	        ЗагрузитьОбъектXDTO(КлючевыеОперации["Item"], Колонки);
	    Иначе
	        Для Каждого ТекЭлемент Из КлючевыеОперации["Item"] Цикл
	            ЗагрузитьОбъектXDTO(ТекЭлемент, Колонки);
	        КонецЦикла;
		КонецЕсли;
	КонецЕсли;
            
    ЧтениеXML.Закрыть();
    УдалитьФайлы(ИмяВременногоФайла);
    
КонецФункции

&НаСервере
Процедура ЗагрузитьОбъектXDTO(ОбъектXDTO, Колонки)
    
    ТекЭлемент = ОбъектXDTO;
	
	КлючеваяОперация = Справочники.КлючевыеОперации.НайтиПоРеквизиту("Имя", ТекЭлемент.Имя);
	Если КлючеваяОперация.Пустая() Тогда
		КлючеваяОперация = ОценкаПроизводительности.СоздатьКлючевуюОперацию(ТекЭлемент.Имя);
	КонецЕсли;
    ПараметрыОтбора = Новый Структура("КлючеваяОперация", КлючеваяОперация);
    НайденныеСтроки = Объект.КлючевыеОперацииПрофиля.НайтиСтроки(ПараметрыОтбора);
    
    Если НайденныеСтроки.Количество() = 0 Тогда
        
        НовСтрока = Объект.КлючевыеОперацииПрофиля.Добавить();
		НовСтрока.КлючеваяОперация = КлючеваяОперация;
        
		Для Каждого ТекКолонка Из Колонки Цикл
			ИмяКолонки = ?(ТекКолонка = "Важность", "Приоритет", ТекКолонка);
            Если НовСтрока.Свойство(ИмяКолонки) И ТекЭлемент.Свойства().Получить(ТекКолонка) <> Неопределено Тогда
                НовСтрока[ИмяКолонки] = ТекЭлемент[ТекКолонка];
            КонецЕсли;
        КонецЦикла;
        
        Если НЕ ЗначениеЗаполнено(НовСтрока.Приоритет) Тогда
            НовСтрока.Приоритет = 5;
        КонецЕсли;
    Иначе
        Для Каждого НовСтрока Из НайденныеСтроки Цикл
			Для Каждого ТекКолонка Из Колонки Цикл
				ИмяКолонки = ?(ТекКолонка = "Важность", "Приоритет", ТекКолонка);
                Если НовСтрока.Свойство(ИмяКолонки) И ТекЭлемент.Свойства().Получить(ТекКолонка) <> Неопределено Тогда
                    НовСтрока[ИмяКолонки] = ТекЭлемент[ТекКолонка];
                КонецЕсли;
            КонецЦикла;
        КонецЦикла;
    КонецЕсли;
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	КлючевыеОперации.Ссылка КАК КлючеваяОперация,
	                      |	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя,
	                      |	ВЫБОР
	                      |		КОГДА КлючевыеОперации.Приоритет = 0
	                      |			ТОГДА 5
	                      |		ИНАЧЕ КлючевыеОперации.Приоритет
	                      |	КОНЕЦ КАК Приоритет
	                      |ИЗ
	                      |	Справочник.КлючевыеОперации КАК КлючевыеОперации
	                      |ГДЕ
	                      |	НЕ КлючевыеОперации.ПометкаУдаления
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	КлючевыеОперации.Наименование");
	Объект.КлючевыеОперацииПрофиля.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

#КонецОбласти
