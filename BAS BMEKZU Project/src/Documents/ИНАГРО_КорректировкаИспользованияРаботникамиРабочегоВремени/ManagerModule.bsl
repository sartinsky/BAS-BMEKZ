#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыИФункцииПечати

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Корректировка использования рабочего времени
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Бланк";
	КомандаПечати.Представление = НСтр("ru='Печать документа';uk='Друк документа'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.СписокФорм    = "ФормаДокумента,ФормаСписка";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru='Реестр документов';uk='Реєстр документів'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru='Реестр документов ""Корректировка использования работниками рабочего времени ""';uk='Реєстр документів ""Коригування використання робітниками робочого часу""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;

КонецПроцедуры

// Выводит на печать подготовленный макет
//
// Параметры:
//	ИмяМакета
//	КоличествоЭкземпляров
//	НаПринтер
//	НепосредственнаяПечать
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Бланк") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Бланк", НСтр("ru='Печать документа';uk='Друк документа'"), 
		ПечатьДокумента(МассивОбъектов, ОбъектыПечати, ПараметрыВывода), , "Документ.ИНАГРО_КорректировкаИспользованияРаботникамиРабочегоВремени.ПФ_MXL_Макет", ,Истина);
	КонецЕсли;  		                                                                                                                     
	
КонецПроцедуры

// Функция формирует печатную форму документа
Функция ПечатьДокумента(МассивОбъектов,ОбъектыПечати, ПараметрыВывода) 
	
	УстановитьПривилегированныйРежим(Истина);
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИНАГРО_КорректировкаИспользованияРаботникамиРабочегоВремени.ПФ_MXL_Макет");
	ПервыйДокумент = Истина;
	ТабДокумент = Новый ТабличныйДокумент;
	Для каждого Ссылка Из МассивОбъектов Цикл
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиВертикальныйРазделительСтраниц();
		КонецЕсли; 
		ПервыйДокумент = Ложь;
		
		// формируем табличную часть документа
		Запрос = Новый Запрос;
		// Установим параметры запроса
		Запрос.УстановитьПараметр("ДокументСсылка",					Ссылка);
		Запрос.УстановитьПараметр("ПустаяДата",						Дата('00010101'));
		Запрос.УстановитьПараметр("СписокНедопустимыхВидовВремени",	ПолучитьСписокНедопустимыхВидовВремени());
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СтрокиТЧ.Сотрудник,
		|	СтрокиТЧ.Назначение,
		|	СтрокиТЧ.ВидИспользованияРабочегоВремени КАК ВидИспользованияРабочегоВремени,
		|	СтрокиТЧ.ВидИспользованияРабочегоВремени.ВидВремени КАК ВидВремени,
		|	ВЫБОР
		|		КОГДА СтрокиТЧ.ВидИспользованияРабочегоВремени.ВидВремени В (&СписокНедопустимыхВидовВремени)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК НедопустимыйВидВремени,
		|	СтрокиТЧ.ДатаНачала КАК ДатаНачала,
		|	ВЫБОР
		|		КОГДА СтрокиТЧ.ДатаОкончания <> &ПустаяДата
		|			ТОГДА НАЧАЛОПЕРИОДА(СтрокиТЧ.ДатаОкончания, ДЕНЬ)
		|		ИНАЧЕ &ПустаяДата
		|	КОНЕЦ КАК ДатаОкончания,
		|	СтрокиТЧ.НомерСтроки КАК НомерСтроки,
		|	СтрокиТЧ.ВсегоДней КАК ВсегоДней,
		|	СтрокиТЧ.ВсегоЧасов КАК ВсегоЧасов,
		|	СтрокиТЧ.Сотрудник.Код КАК ТабНом
		|ИЗ
		|	Документ.ИНАГРО_КорректировкаИспользованияРаботникамиРабочегоВремени.ОтработанноеВремя КАК СтрокиТЧ
		|ГДЕ
		|	СтрокиТЧ.Ссылка = &ДокументСсылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		ОтработанноеВремя = Запрос.Выполнить();
	
	// Получаем данные для печати
	ТаблицаДок = ОтработанноеВремя.Выгрузить();
	Макет = ПолучитьМакет("ПФ_MXL_Макет");
	
	// Печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = ПараметрыВывода.КодЯзыкаДляМногоязычныхПечатныхФорм;
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;                                                                                                                      
	СведенияОбОрганизации =БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Ссылка.Организация, Ссылка.Дата,,,КодЯзыкаПечать);
	ОблЗаголовок = Макет.ПолучитьОбласть("ОблЗаголовок");
	ОблЗаголовок.Параметры.Организация = Ссылка.Организация.НаименованиеПолное;                                                                                                           
	ОблЗаголовок.Параметры.ТекДата = ТекущаяДата();
	ОблЗаголовок.Параметры.ПодразделениеОрганизации = Ссылка.ПодразделениеОрганизации;
	ОблЗаголовок.Параметры.ПериодСтр = Формат(Ссылка.ПериодРегистрации,"Л="+ КодЯзыкаПечать +"_UA; ДФ='ММММ гггг'")+НСтр("ru=' г.';uk=' р.'",КодЯзыкаПечать);
	ТабДокумент.Вывести(ОблЗаголовок);
	
	Область = Макет.ПолучитьОбласть("Шапка");
	ТабДокумент.Вывести(Область);
	Область = Макет.ПолучитьОбласть("Детали"); 
	Ном = 0;
	
	// Начинаем формировать выходной документ
	Для каждого Строка_ Из ТаблицаДок Цикл
		Ном = Ном+1;
		Область.Параметры.Заполнить(Строка_);
		Область.Параметры.Номер = Ном;
		ТабДокумент.Вывести(Область);
	КонецЦикла;
	
	КонецЦикла; 
	Возврат ТабДокумент;
	
КонецФункции

// Возвращает список видов времени, которые нельзя вводить этим документом
//
// Параметры
//	Нет.
//
// Возвращаемое значение:
//	Список значений, содержащий подходящий перечень значений перечисления ВидыВремени.
//
Функция ПолучитьСписокНедопустимыхВидовВремени() 
	
	Список = Новый СписокЗначений;
	Список.Добавить(Перечисления.ИНАГРО_ВидыВремени.ОтработанноеСверхНормы);
	Список.Добавить(Перечисления.ИНАГРО_ВидыВремени.ЧасовоеНеотработанное);
	
	Возврат Список;
	
КонецФункции

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;	
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти 

#КонецЕсли 