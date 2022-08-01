#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 

	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		// Заполним реквизиты из значений заполнения
		Если Параметры.Свойство("Организация") И ЗначениеЗаполнено(Параметры.Организация) Тогда 
			Объект.Организация = Параметры.Организация;
		КонецЕсли;
		Если Параметры.Свойство("Подразделение") И ЗначениеЗаполнено(Параметры.Подразделение) Тогда 
			Объект.Подразделение = Параметры.Подразделение;
		КонецЕсли;
		
		Если Параметры.Свойство("Сотрудник") И ЗначениеЗаполнено(Параметры.Сотрудник) Тогда 
			
			Объект.Организация = Параметры.Сотрудник.ГоловнаяОрганизация;
			СтрокаРаботник = Объект.РаботникиОрганизации.Добавить();
			СтрокаРаботник.Сотрудник = Параметры.Сотрудник;
			СтрокаРаботник.ДатаУвольнения = ТекущаяДата();
	
		КонецЕсли;
		
		УстановитьФункциональныеОпцииФормы();
		
	КонецЕсли;
		
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Сотрудники") Тогда
		ДобавляемыеСотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранноеЗначение);
	Иначе
		ДобавляемыеСотрудники = ВыбранноеЗначение;
	КонецЕсли;

	ДобавитьСотрудников(ДобавляемыеСотрудники);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ГрупповоеЗаполнение" И ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.Свойство("ИдентификаторВызывающейФормы")
		И Параметр.ИдентификаторВызывающейФормы = УникальныйИдентификатор Тогда
		ВыполнитьГрупповоеЗаполнение(Параметр);
	КонецЕсли;
	
	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере(); 

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьСостояниеДокумента();	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРаботникиОрганизаций

&НаКлиенте
Процедура РаботникиОрганизацииСотрудникПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.РаботникиОрганизации.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.Сотрудник) И Не ЗначениеЗаполнено(ТекущаяСтрока.ДатаУвольнения) Тогда
		ТекущаяСтрока.ДатаУвольнения = ТекущаяДата();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.РаботникиОрганизации.Количество() > 0 Тогда
		 
		ТекстВопроса = НСтр("ru='Перед заполнением табличные части будут очищены. Продолжить?';uk='Перед заповненям табличні частини будуть очищені. Продовжити?'");
		Оповещение = Новый ОписаниеОповещения("ОчиститьТаблицыЗавершение", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		Возврат;
	КонецЕсли;
		
	Объект.РаботникиОрганизации.Очистить();
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма)
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПодобратьСотрудников(Истина);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
		
	УстановитьСостояниеДокумента();
			
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация, Период", Объект.Организация, Объект.Дата);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицыЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 
   	
    Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
        Возврат;
	Иначе 
		Объект.РаботникиОрганизации.Очистить();
	КонецЕсли;
			
	ИНАГРО_ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма)
		     
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьГрупповоеЗаполнение(Параметр)
	
	ВыполнитьГрупповоеЗаполнениеНаСервере(Параметр);		
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьГрупповоеЗаполнениеНаСервере(Параметр)
	
	ТаблицаСотрудников = ПолучитьИзВременногоХранилища(Параметр.АдресТЗ);
	Если ТаблицаСотрудников.Колонки.Найти("ДатаНачала") <> Неопределено Тогда
		ТаблицаСотрудников.Колонки["ДатаНачала"].Имя = "ДатаУвольнения"; 
	КонецЕсли;
	
	Объект.РаботникиОрганизации.Загрузить(ТаблицаСотрудников);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСотрудников(МножественныйВыбор)
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериоде(
		ЭтаФорма, Объект.Организация, Неопределено,
		Объект.Дата, КонецМесяца(Объект.Дата), МножественныйВыбор,
		АдресСпискаПодобранныхСотрудников());
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСотрудников(Знач СписокСотрудников)
	
	СотрудникиКДобавлению = Новый Массив;
	Для каждого ДобавляемыйСотрудник Из СписокСотрудников Цикл
		
		Если Объект.РаботникиОрганизации.НайтиСтроки(Новый Структура("Сотрудник", ДобавляемыйСотрудник)).Количество() = 0 Тогда
			НоваяСтрока = Объект.РаботникиОрганизации.Добавить();
			НоваяСтрока.Сотрудник = ДобавляемыйСотрудник;
			НоваяСтрока.ДатаУвольнения = ТекущаяДата();
		КонецЕсли; 
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.РаботникиОрганизации.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

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

