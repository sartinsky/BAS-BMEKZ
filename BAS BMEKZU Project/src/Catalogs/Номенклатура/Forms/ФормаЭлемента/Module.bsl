#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
    ФормироватьНаименованиеПолноеАвтоматически = УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(Объект.НаименованиеПолное,Объект.Наименование);
	
	СчетаУчетаОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	СчетаУчетаСклад = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнойСклад");
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	
	УправлениеФормой(ЭтаФорма);
	УстановитьВидКодаДляНН(Объект.НоменклатураГТД, Элементы.ДекорацияВидКодаДляНН.Заголовок);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	Если Не Отказ И Объект.Ссылка.Пустая() Тогда
		
		СохраняемыеЗначенияРеквизитов = Новый Структура(
			"СтавкаНДС,ЛьготаНДС,КодЛьготы");	
		ЗаполнитьЗначенияСвойств(СохраняемыеЗначенияРеквизитов, Объект);
		
		ХранилищеОбщихНастроек.Сохранить("Номенклатура_СохраняемыеЗначенияРеквизитов",, СохраняемыеЗначенияРеквизитов);	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если ФормироватьНаименованиеПолноеАвтоматически Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Список = Новый СписокЗначений();
	Список.Добавить(Объект.Наименование);

	// Выбор из списка и обработка выбора.
	Оповещение = Новый ОписаниеОповещения("НаименованиеПолноеНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(Оповещение, Список, Элементы.НаименованиеПолное);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.НаименованиеПолное = Результат.Значение;
		Модифицированность = Истина;
		ФормироватьНаименованиеПолноеАвтоматически = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)
    
    ФормироватьНаименованиеПолноеАвтоматически = УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(Элементы.НаименованиеПолное,Элементы.Наименование);

КонецПроцедуры

&НаКлиенте
Процедура УслугаПриИзменении(Элемент)
	
	Если Не Объект.Услуга Тогда
		Объект.ИзмеряетсяТолькоВСуммовомВыражении = Ложь;
	КонецЕсли;
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура БланкСтрогогоУчетаПриИзменении(Элемент)

	Если Не Объект.БланкСтрогогоУчета Тогда
		Объект.УчитываетсяПоНоминальнойСтоимости = Ложь;
	КонецЕсли;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	
	Если Объект.СтавкаНДС <> ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС") 
	   И Объект.СтавкаНДС <> ПредопределенноеЗначение("Перечисление.СтавкиНДС.НеНДС") Тогда 
		Объект.ЛьготаНДС = "";
		Объект.КодЛьготы = "";
	КонецЕсли;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмеряетсяТолькоВСуммовомВыраженииПриИзменении(Элемент)
	
	Если НЕ Объект.ИзмеряетсяТолькоВСуммовомВыражении Тогда
		Объект.ТекстДляПечатиВКолонкеКоличествоНалоговойНакладной = "";
	КонецЕсли;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяСпецификацияНоменклатурыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстВопроса = НСтр("ru='Данные еще не записаны.';uk='Дані ще не записані.'")
			+ Символы.ПС
			+ НСтр("ru='Выбор основной спецификации возможен только после записи данных.';uk='Вибір основної специфікації можливий тільки після запису даних.'")
			+ Символы.ПС
			+ НСтр("ru='Данные будут записаны.';uk='Дані будуть записані.'");
			
		Оповещение = Новый ОписаниеОповещения("ВопросВыборСпецификацииПослеЗаписиЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросВыборСпецификацииПослеЗаписиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Если ПроверитьЗаполнение() Тогда
			Записать();
			ПараметрыОтбора = Новый Структура("Владелец", Объект.Ссылка);
			ПараметрыФормы = Новый Структура("Отбор, МножественныйВыбор", ПараметрыОтбора, Ложь);
			ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОсновнаяСпецификацияНоменклатурыНачалоВыбораЗавершение", ЭтотОбъект);
			ОткрытьФорму("Справочник.СпецификацииНоменклатуры.ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,, ОповещениеОЗакрытии);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЕдиницыИзмеренияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда
		Отказ = Истина;	               
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницыИзмеренияПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ЕдиницыИзмерения.ТекущиеДанные;
	
	Если НЕ ТекущиеДанные = Неопределено Тогда
		Если ТекущиеДанные.ЕдиницаИзмерения = Объект.БазоваяЕдиницаИзмерения Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницыИзмеренияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
 	ТекущиеДанные = Элементы.ЕдиницыИзмерения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтменаРедактирования Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ТекущиеДанные.ЕдиницаИзмерения.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указана единица измерения!';uk='Не зазначена одиниця виміру!'"), , "ЕдиницыИзмерения", , Отказ);
		Возврат;
	КонецЕсли;	
	
	Если ТекущиеДанные.Коэффициент = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указан коэффициент!';uk='Не зазначений коефіцієнт!'"), , "ЕдиницыИзмерения", , Отказ);
		Возврат;
	КонецЕсли;	
	
	Если Объект.ЕдиницыИзмерения.НайтиСтроки(Новый Структура("ЕдиницаИзмерения", ТекущиеДанные.ЕдиницаИзмерения)).Количество() > 1 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Данная единица измерения уже зарегистрирована для номенклатуры!';uk='Дана одиниця виміру вже зареєстрована для номенклатури!'"), , "ЕдиницыИзмерения", , Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьСчетаУчетаДляИспользуемых(Команда)
	
	Если ЕстьЗаписьСчетаУчетаНоменклатуры(СчетаУчета) Тогда
		
		СтруктураКлючаЗаписи = Новый Структура;
		СтруктураКлючаЗаписи.Вставить("Организация", СчетаУчета.Организация);
		СтруктураКлючаЗаписи.Вставить("Склад", СчетаУчета.Склад);
		СтруктураКлючаЗаписи.Вставить("ТипСклада", СчетаУчета.ТипСклада);
		СтруктураКлючаЗаписи.Вставить("Номенклатура", СчетаУчета.Номенклатура);
		
		КлючЗаписи = ПолучитьКлючЗаписиСчетаУчетаНоменклатуры(СтруктураКлючаЗаписи);
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Ключ", КлючЗаписи);
		
		ОткрытьФорму("РегистрСведений.СчетаУчетаНоменклатуры.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма);
			
	Иначе
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Организация", СчетаУчета.Организация);
		ЗначенияЗаполнения.Вставить("Склад", СчетаУчета.Склад);
		ЗначенияЗаполнения.Вставить("Номенклатура", СчетаУчета.Номенклатура);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("РегистрСведений.СчетаУчетаНоменклатуры.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСчетаУчетаПоФильтру(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", СчетаУчетаОрганизация);
	ЗначенияЗаполнения.Вставить("Склад", СчетаУчетаСклад);
	ЗначенияЗаполнения.Вставить("Номенклатура", Объект.Ссылка);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("РегистрСведений.СчетаУчетаНоменклатуры.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетаУчетаОбновить(Команда)
	
	ОбновитьСчетаУчета();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает доступность реквизитов формы.
//
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
    Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.Услуга.Доступность = НЕ Объект.БланкСтрогогоУчета;
	Элементы.ИзмеряетсяТолькоВСуммовомВыражении.Доступность = Объект.Услуга;
	Элементы.БланкСтрогогоУчета.Доступность = НЕ Объект.Услуга;
	Элементы.УчитываетсяПоНоминальнойСтоимости.Доступность = Объект.БланкСтрогогоУчета;
	Если Объект.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС") 
		ИЛИ Объект.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НеНДС") 
		Тогда
		Элементы.ЛьготаНДС.Доступность = Истина;
		Элементы.КодЛьготы.Доступность = Истина;
	Иначе
		Элементы.ЛьготаНДС.Доступность = Ложь;
		Элементы.КодЛьготы.Доступность = Ложь;
	КонецЕсли;
	Элементы.ТекстДляПечатиВКолонкеКоличествоНалоговойНакладной.Доступность = Объект.ИзмеряетсяТолькоВСуммовомВыражении;
	
	ОбъектЗаписан = ЗначениеЗаполнено(Объект.Ссылка);
	Элементы.СтраницаЕдиницыИзмерения.Доступность = ОбъектЗаписан;
	Элементы.СтраницаСчетаУчета.Доступность = ОбъектЗаписан;
	Если ОбъектЗаписан Тогда 
		Элементы.СтраницаБухгалтерскийУчет.Видимость = НЕ Объект.Услуга;
		Элементы.СтраницаБухгалтерскийУчетУслуги.Видимость = Объект.Услуга;
	КонецЕсли;
	Элементы.ПодакцизныйТовар.Доступность = НЕ Объект.Услуга;
	Элементы.СтатьяДекларацииПоАкцизномуНалогу.Доступность = Объект.ПодакцизныйТовар;
    Элементы.ИНАГРО_УдобрениеПроцент.Доступность = Объект.ИНАГРО_Удобрение; // ИНАГРО
    
КонецПроцедуры // УстановитьДоступность()

// и присваивает соответствующее значение переменной ФормироватьНаименованиеПолноеАвтоматически.
//
// Параметры:
//  Нет.
//
&НаКлиентеНаСервереБезКонтекста
Функция УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(НаименованиеПолное,Наименование)
   
   Возврат (ПустаяСтрока(НаименованиеПолное) ИЛИ НаименованиеПолное = Наименование);
   
КонецФункции // УстановитьФлагФормироватьНаименованиеПолноеАвтоматически()

&НаСервере
Процедура ОбновитьСчетаУчета() 
	
	СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаУчетаНоменклатуры(СчетаУчетаОрганизация,Объект.Ссылка,СчетаУчетаСклад);
	
	СчетУчетаБУ 				= СчетаУчета.СчетУчетаБУ;
	СубконтоБУ1 				= СчетаУчета.СубконтоБУ1;
	СубконтоБУ2 				= СчетаУчета.СубконтоБУ2;
	СубконтоБУ3 				= СчетаУчета.СубконтоБУ3;
	СчетУчетаПередачиБУ 		= СчетаУчета.СчетПередачиБУ;
	СчетУчетаЗабалансовыйБУ 	= СчетаУчета.СчетУчетаДоп;
	СчетУчетаПередачиЗабалансовыйБУ = СчетаУчета.СчетПередачиЗабБУ;
	СхемаРеализации 			= СчетаУчета.СхемаРеализации;
	НалоговоеНазначение 		= СчетаУчета.НалоговоеНазначение;
	НалоговоеНазначениеДоходовИЗатрат 		= СчетаУчета.НалоговоеНазначениеДоходовИЗатрат;
	
	ТекстИнфо = НСтр("ru='для';uk='для'");
	Если ЗначениеЗаполнено(СчетаУчета.Номенклатура) Тогда
		Если НЕ СчетаУчета.Номенклатура = Объект.Ссылка Тогда
			ТекстИнфо = ТекстИнфо + НСтр("ru=' группы номенклатуры ""';uk=' групи номенклатури ""'")+СчетаУчета.Номенклатура+""",";
		Иначе
			ТекстИнфо = ТекстИнфо + НСтр("ru=' данной номенклатуры,';uk=' даної номенклатури,'");
		КонецЕсли;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(СчетаУчета.Склад) Тогда
		Если НЕ ЗначениеЗаполнено(СчетаУчета.ТипСклада) Тогда
			ТекстИнфо = ТекстИнфо + НСтр("ru=' всех складов';uk=' всіх складів'")
		Иначе
			ТекстИнфо = ТекстИнфо + НСтр("ru=' типа складов ""';uk=' типу складів ""'")+СчетаУчета.ТипСклада+"""";
		КонецЕсли;
	Иначе
		Если СчетаУчета.Склад.ЭтоГруппа Тогда
			ТекстИнфо = ТекстИнфо + НСтр("ru=' группы складов ""';uk=' групи складів ""'")+СчетаУчета.Склад+"""";
		Иначе
			ТекстИнфо = ТекстИнфо + НСтр("ru=' склада ""';uk=' складу ""'")+СчетаУчета.Склад+"""";
		КонецЕсли;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(СчетаУчета.Организация) Тогда
		ТекстИнфо = ТекстИнфо + НСтр("ru=', всех организаций';uk=', всіх організацій'");
	Иначе
		ТекстИнфо = ТекстИнфо + НСтр("ru=', организации ""';uk=', організації ""'")+СчетаУчета.Организация+"""";
	КонецЕсли;
	
	Элементы.НадписьУстановленоДля.Заголовок = НСтр("ru='Настроены ';uk='Настроєні '")+ТекстИнфо;

	// Настроим действия для кнопки
	Если НЕ (СчетаУчетаОрганизация=СчетаУчета.Организация И СчетаУчетаСклад=СчетаУчета.Склад И Объект.Ссылка=СчетаУчета.Номенклатура) Тогда
		
		ТекстТекущий  = НСтр("ru='для данной номенклатуры,';uk='для даної номенклатури,'");
		Если НЕ ЗначениеЗаполнено(СчетаУчетаСклад) Тогда
			ТекстТекущий = ТекстТекущий + НСтр("ru=' всех складов';uk=' всіх складів'")
		Иначе
			ТекстТекущий = ТекстТекущий + НСтр("ru=' склада ""';uk=' складу ""'")+СчетаУчетаСклад+"""";
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СчетаУчетаОрганизация) Тогда
			ТекстТекущий = ТекстТекущий + НСтр("ru=', всех организаций';uk=', всіх організацій'");
		Иначе
			ТекстТекущий = ТекстТекущий + НСтр("ru=', организации ""';uk=', організації ""'")+СчетаУчетаОрганизация+"""";
		КонецЕсли;
	
		Элементы.НастроитьСчетаУчетаПоФильтру.Заголовок = ТекстТекущий;
		Элементы.НастроитьСчетаУчетаПоФильтру.Видимость = Истина;
		
	Иначе
		
		Элементы.НастроитьСчетаУчетаПоФильтру.Видимость = Ложь;
		
	КонецЕсли; 

	Элементы.НастроитьСчетаУчетаДляИспользуемых.Заголовок = ТекстИнфо;
	
	Если Объект.Услуга Тогда
		
		Для Ном = 1 по 3 Цикл
			Если (Ном <= СчетУчетаБУ.ВидыСубконто.Количество()) и (ЗначениеЗаполнено(СчетУчетаБУ)) Тогда
				Элементы["СубконтоБУ"+Ном].Заголовок = Строка(СчетУчетаБУ.ВидыСубконто[Ном-1].ВидСубконто);
				Элементы["СубконтоБУ"+Ном].Видимость        = Истина;
			Иначе
				Элементы["СубконтоБУ"+Ном].Видимость        = Ложь;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетаУчетаОрганизацияПриИзменении(Элемент)
	
	ОбновитьСчетаУчета();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетаУчетаСкладПриИзменении(Элемент)
	
	ОбновитьСчетаУчета();

КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаСчетаУчета Тогда
		ОбновитьСчетаУчета();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьЗаписьСчетаУчетаНоменклатуры(СтруктураИзмерений)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", СтруктураИзмерений.Организация);
	Запрос.УстановитьПараметр("Склад", СтруктураИзмерений.Склад);
	Запрос.УстановитьПараметр("ТипСклада", СтруктураИзмерений.ТипСклада);
	Запрос.УстановитьПараметр("Номенклатура", СтруктураИзмерений.Номенклатура);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИСТИНА КАК Запись
	|ИЗ
	|	РегистрСведений.СчетаУчетаНоменклатуры КАК СчетаУчетаНоменклатуры
	|ГДЕ
	|	СчетаУчетаНоменклатуры.Организация = &Организация
	|	И СчетаУчетаНоменклатуры.Номенклатура = &Номенклатура
	|	И СчетаУчетаНоменклатуры.Склад = &Склад
	|	И СчетаУчетаНоменклатуры.ТипСклада = &ТипСклада";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьКлючЗаписиСчетаУчетаНоменклатуры(СтруктураКлючаЗаписи)
	
	Возврат РегистрыСведений.СчетаУчетаНоменклатуры.СоздатьКлючЗаписи(СтруктураКлючаЗаписи);
	
КонецФункции

&НаКлиенте
Процедура ПодакцизныйТоварПриИзменении(Элемент)
	
	Если Не Объект.ПодакцизныйТовар Тогда
		Объект.СтатьяДекларацииПоАкцизномуНалогу = ПредопределенноеЗначение("Справочник.СтатьиНалоговыхДеклараций.ПустаяСсылка");
	КонецЕсли;	

	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураГТДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВариантыВыбора = Новый СписокЗначений();
	ВариантыВыбора.Добавить(Ложь,   НСтр("ru='Выбрать из кодов номенклатуры';uk='Вибрати з кодів номенклатури'"));
	ВариантыВыбора.Добавить(Истина, НСтр("ru='Выбрать из классификатора';uk='Вибрати із класифікатора'"));
	
	Оповещение = Новый ОписаниеОповещения("НоменклатураГТДНачалоВыбораЗавершение", ЭтотОбъект, Элемент);
	ПоказатьВыборИзСписка(Оповещение, ВариантыВыбора, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураГТДНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатВыбора.Значение = Истина Тогда
		ПараметрыОткрытия = Новый Структура("ТекущаяСтрока");
		Если ЗначениеЗаполнено(Объект.НоменклатураГТД) И ТипЗнч(Объект.НоменклатураГТД) = Тип("СправочникСсылка.КлассификаторУКТВЭД") Тогда
			ПараметрыОткрытия.Вставить("ТекущаяСтрока", Объект.НоменклатураГТД);	
		КонецЕсли; 
		ОткрытьФорму("Справочник.КлассификаторУКТВЭД.Форма.ФормаВыбора", ПараметрыОткрытия, ДополнительныеПараметры);
	Иначе
		ПараметрыОткрытия = Новый Структура("Отбор, ТекущаяСтрока", Новый Структура("Владелец", Объект.Ссылка));
		Если ЗначениеЗаполнено(Объект.НоменклатураГТД) И ТипЗнч(Объект.НоменклатураГТД) = Тип("СправочникСсылка.НоменклатураГТД") Тогда
			ПараметрыОткрытия.Вставить("ТекущаяСтрока", Объект.НоменклатураГТД);	
		КонецЕсли;
		ОткрытьФорму("Справочник.НоменклатураГТД.Форма.ФормаВыбора", ПараметрыОткрытия, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура НоменклатураГТДПриИзменении(Элемент)
	
	УстановитьВидКодаДляНН(Объект.НоменклатураГТД, Элементы.ДекорацияВидКодаДляНН.Заголовок);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьВидКодаДляНН(НоменклатураГТД, ЗаголовокДекорацииВидКодаДляНН)
	
	ВидКодаДляНН = "";
	
	Если ЗначениеЗаполнено(НоменклатураГТД) Тогда
		Если ТипЗнч(НоменклатураГТД) = Тип("СправочникСсылка.КлассификаторУКТВЭД") Тогда
			ВидКодаДляНН = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НоменклатураГТД, "Вид");
		ИначеЕсли ТипЗнч(НоменклатураГТД) = Тип("СправочникСсылка.НоменклатураГТД") Тогда
			ВидКодаДляНН = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НоменклатураГТД, "КодУКТВЭД.Вид");
		КонецЕсли;
	КонецЕсли;
		
	ЗаголовокДекорацииВидКодаДляНН = ВидКодаДляНН;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИНАГРО_УдобрениеПриИзменении(Элемент)  // ИНАГРО
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры  
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти