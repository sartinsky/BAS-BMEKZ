#Область ПрограммныйИнтерфейс

// Возвращает список доступных типов оборудования
//
Функция ПолучитьДоступныеТипыОборудования() Экспорт
	
	СписокОборудования = Новый Массив;
	
	// Электронные весы
	СписокОборудования.Добавить(Перечисления.ИНАГРО_ТипыПодключаемогоОборудования.ЭлектронныеВесы);
	// Конец Электронные весы
		
	Возврат СписокОборудования;
	
КонецФункции

// Возвращает флаг возможности добавления новых драйверов в справочник драйверов
//
Функция ВозможностьДобавленияНовыхДрайверов() Экспорт
	
	МожноДобавлятьНовыеДрайвера = Истина;
	Возврат МожноДобавлятьНовыеДрайвера;
	
КонецФункции

// Возвращает признак возможности обращения к разделенным данным из текущего сеанса.
// В случае вызова в неразделенной конфигурации возвращает Истина.
//
// Возвращаемое значение:
// Булево.
//
Функция ДоступноИспользованиеРазделенныхДанных() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Обновить поставляемые драйверы в составе конфигурации
//                                   
Процедура ОбновитьПоставляемыеДрайвера() Экспорт
		
	// ИНАГРО Электронные весы
	Справочники.ИНАГРО_ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ИНАГРО_ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикMSCommЭлектронныеВесы, "MSCOMMLib.MSComm.1", "ДрайверMSCommЭлектронныеВесы", Истина);	
	Справочники.ИНАГРО_ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ИНАГРО_ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикWP89ЭлектронныеВесы, "AddIn.WP89", "ДрайверWP89ЭлектронныеВесы", Истина);		
	// ИНАГРО Конец Электронные весы
		
КонецПроцедуры

// Обновление поля "ДрайверОборудования" в справочнике подключаемого оборудования
Процедура ОбновитьДрайверыВСправочникеПодключаемогоОборудования() Экспорт
	      
	НеобходимоОбновлениеДрайвера = Ложь;
	ОбновлениеДрайвераВыполнено  = Ложь;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
						  |ПодключаемоеОборудование.Ссылка,
						  |ПодключаемоеОборудование.УдалитьОбработчикДрайвера
						  |ИЗ
						  |Справочник.ИНАГРО_ПодключаемоеОборудование КАК ПодключаемоеОборудование");
	
	Выборка = Запрос.Выполнить().Выбрать();
				   
	Пока Выборка.Следующий() Цикл
		
		Драйвер = Неопределено;
				
		ВремИмяЭлемента = ИНАГРО_МенеджерОборудованияВызовСервера.ПолучитьПараметрыДрайвераПоОбработчику(Строка(Выборка.УдалитьОбработчикДрайвера));
		
		Если ВремИмяЭлемента.Свойство("Имя") Тогда 
			ВремИмяДрайвера = СтрЗаменить(ВремИмяЭлемента.Имя, "Обработчик", "Драйвер");
			Попытка
				Драйвер = ИНАГРО_МенеджерОборудованияВызовСервера.ПредопределенныйЭлемент("Справочник.ИНАГРО_ДрайверыОборудования." + ВремИмяДрайвера);
			Исключение
			КонецПопытки;
		КонецЕсли;
		
		Если Драйвер <> Неопределено Тогда
			ПодключаемоеОборудование = Выборка.Ссылка.ПолучитьОбъект();
			// Необходимо обновление драйвера "1С:Сканер штрихкода"
			Если НеобходимоОбновлениеДрайвера И Не ОбновлениеДрайвераВыполнено Тогда
				ПодключаемоеОборудование.ТребуетсяУстановка = Истина;
				ОбновлениеДрайвераВыполнено = Истина;
			КонецЕсли;
			ПодключаемоеОборудование.ДрайверОборудования = Драйвер;
			ПодключаемоеОборудование.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСФормойЭкземпляраОборудования

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриСозданииНаСервере"
//
Процедура ЭкземплярОборудованияПриСозданииНаСервере(Объект, ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка) Экспорт
		
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЧтенииНаСервере"
//
Процедура ЭкземплярОборудованияПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписьюНаСервере"
//
Процедура ЭкземплярОборудованияПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЗаписиНаСервере"
//
Процедура ЭкземплярОборудованияПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписиНаСервере"
//
Процедура ЭкземплярОборудованияПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ОбработкаПроверкиЗаполненияНаСервере"
//
Процедура ЭкземплярОборудованияОбработкаПроверкиЗаполненияНаСервере(Объект, ЭтаФорма, Отказ, ПроверяемыеРеквизиты) Экспорт

КонецПроцедуры

#КонецОбласти

#Область Прочее

#КонецОбласти
