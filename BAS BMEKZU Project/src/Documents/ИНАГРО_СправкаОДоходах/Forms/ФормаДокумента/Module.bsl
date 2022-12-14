#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 

	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);  	
		
	УстановитьДоступностьЭлементов();
			
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьДоступностьЭлементов();

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ОчиститьТабличныеЧасти();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ОчиститьТабличныеЧасти();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидСправкиПриИзменении(Элемент)
	
	ВидСправкиПриИзмененииНаСервере();
	
	УстановитьДоступностьЭлементов()

КонецПроцедуры

&НаСервере
Процедура ВидСправкиПриИзмененииНаСервере()
	
	ОчиститьТабличныеЧасти();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если    Объект.ВидСправки = ПредопределенноеЗначение("Перечисление.ВидыСправокОДоходах.Соцстрах") 
		ИЛИ Объект.ВидСправки = ПредопределенноеЗначение("Перечисление.ВидыСправокОДоходах.Субсидия") 
		ИЛИ Объект.ВидСправки = ПредопределенноеЗначение("Перечисление.ВидыСправокОДоходах.Безработица") 
		ИЛИ Объект.ВидСправки = ПредопределенноеЗначение("Перечисление.ВидыСправокОДоходах.Пенсия") Тогда
		ТекстСообщения = НСтр("ru='Выбрана устаревшая форма справки!';uk='Обрана застаріла форма довідки!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;	
	
	Если Объект.Доходы.Количество() > 0 Тогда
	
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
        Возврат; 
		
	КонецЕсли;

	ЗаполнитьПослеЗавершения();
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗаполнитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
	КонецЕсли; 
	
    Объект.Доходы.Очистить();
    
    ЗаполнитьПослеЗавершения();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПослеЗавершения()
    
    ЗаполнитьНаСервере();
	
    ПослеЗаполненияНаСервере();

КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.Автозаполнение();
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект")
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаполненияНаСервере()
	
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	// Отключаем видимость всех элементов
	ЭтаФорма.Элементы.НазначениеСправки.Видимость = Ложь;
		
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыОтработаноДней.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыВсегоОблагаемое.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыПредел.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатВсего.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатОсновное.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатСовместительство.Видимость = Ложь;
		
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыСовокупныйДоход.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыСуммаКВыплате.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыУдержания.Видимость = Ложь;
		
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНачисленоЗП.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНачисленоПрочее.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыАлименты.Видимость = Ложь;
		
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыКалендарныеДни.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатВзносы.Видимость = Ложь;
		
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыДоходНДФЛ.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНДФЛ.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыОблагаемоеЕСВ.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыОблагаемоеЕСВПредел.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыВыплачено.Видимость = Ложь;
		
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыДоходВоенныйСбор.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыВоенныйСбор.Видимость = Ложь;
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыДоходЗаВычетомНДФЛ.Видимость = Ложь;

	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНДФЛПрочее.Видимость = Ложь;
	
	ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыСтавкаВзносов.Видимость = Ложь;
	
	// Включаем видимость нужных элементов
	Если Объект.ВидСправки = Перечисления.ВидыСправокОДоходах.Произвольная Тогда
		
		ЭтаФорма.Элементы.НазначениеСправки.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыСовокупныйДоход.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыСуммаКВыплате.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыУдержания.Видимость = Истина;
		
	ИначеЕсли Объект.ВидСправки = Перечисления.ВидыСправокОДоходах.Соцстрах Тогда
		
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыОтработаноДней.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыВсегоОблагаемое.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыПредел.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатВсего.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатОсновное.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатСовместительство.Видимость = Истина;
		
	ИначеЕсли Объект.ВидСправки = Перечисления.ВидыСправокОДоходах.Безработица Тогда
		
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыВсегоОблагаемое.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыВсегоОблагаемое.Доступность = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыПредел.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатВсего.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыКалендарныеДни.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатВзносы.Видимость = Истина;	
		
	ИначеЕсли Объект.ВидСправки = Перечисления.ВидыСправокОДоходах.Пенсия Тогда
		
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыВсегоОблагаемое.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатВсего.Видимость = Истина;
		
	ИначеЕсли Объект.ВидСправки = Перечисления.ВидыСправокОДоходах.Субсидия Тогда
		
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыСовокупныйДоход.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНачисленоЗП.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНачисленоПрочее.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыАлименты.Видимость = Истина;
	
	ИначеЕсли Объект.ВидСправки = Перечисления.ВидыСправокОДоходах.ДоходыИНалоги Тогда
		
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатВзносы.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыДоходНДФЛ.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНДФЛ.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыДоходВоенныйСбор.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыВоенныйСбор.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыДоходЗаВычетомНДФЛ.Видимость = Истина;
		
	ИначеЕсли Объект.ВидСправки = Перечисления.ВидыСправокОДоходах.Субсидия2015 Тогда
		
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыСовокупныйДоход.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНачисленоЗП.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНачисленоПрочее.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНДФЛ.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыНДФЛПрочее.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыАлименты.Видимость = Истина;
		
	ИначеЕсли Объект.ВидСправки = Перечисления.ВидыСправокОДоходах.Соцстрах2015 Тогда	
		
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатВсего.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыКалендарныеДни.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатВзносы.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыСтавкаВзносов.Видимость = Истина;
		
	ИначеЕсли Объект.ВидСправки = Перечисления.ВидыСправокОДоходах.Пенсия2015 Тогда
		
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыВсегоОблагаемое.Видимость = Истина;
		ЭтаФорма.Элементы.Доходы.ПодчиненныеЭлементы.ДоходыРезультатВсего.Видимость  = Истина;		
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов()
	
	Если Объект.Доходы.Количество() > 0 Тогда
		ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.Отображать;
	Иначе
		ОтображениеПредупреждения = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
	КонецЕсли;
	
	Элементы.Организация.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупреждения;
	Элементы.Сотрудник.ОтображениеПредупрежденияПриРедактировании   = ОтображениеПредупреждения;
	Элементы.ВидСправки.ОтображениеПредупрежденияПриРедактировании  = ОтображениеПредупреждения;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьТабличныеЧасти()
	
	Объект.Доходы.Очистить();
	
	УстановитьОтображениеПредупрежденийПриИзмененииКлючевыхРеквизитов();
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти