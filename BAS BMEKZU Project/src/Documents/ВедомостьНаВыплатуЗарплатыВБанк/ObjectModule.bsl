#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции заполнения документа

Функция МожноЗаполнитьАвтоматически() Экспорт
	Возврат ВзаиморасчетыССотрудниками.ВедомостьВБанкМожноЗаполнитьАвтоматически(ЭтотОбъект);
КонецФункции

Функция МожноРассчитатьНалоги() Экспорт
	Возврат ВзаиморасчетыССотрудниками.ВедомостьМожноРассчитатьНалоги(ЭтотОбъект);
КонецФункции
Процедура ДобавитьЛицевыеСчета(МассивСотрудников)
	
	ЛицевыеСчетаСотрудников = ЗарплатныеПроекты.ЛицевыеСчетаСотрудников(МассивСотрудников, Истина, Организация, ПериодРегистрации, ЗарплатныйПроект);
	
	Для Каждого СтрокаТЧ Из Зарплата Цикл
		СтрокаЛС = ЛицевыеСчетаСотрудников.Найти(СтрокаТЧ.ФизическоеЛицо, "ФизическоеЛицо");
		Если СтрокаЛС = Неопределено Тогда
			СтрокаТЧ.НомерЛицевогоСчета = "";
		Иначе
			СтрокаТЧ.НомерЛицевогоСчета = СтрокаЛС.НомерЛицевогоСчета
		КонецЕсли
	КонецЦикла
	
КонецПроцедуры

Процедура ЗаполнитьАвтоматически() Экспорт
	
	ВзаиморасчетыССотрудниками.ВедомостьЗаполнитьАвтоматически(ЭтотОбъект, МестоВыплаты());
	
	МассивФизическихЛиц = Зарплата.ВыгрузитьКолонку("ФизическоеЛицо");
	
	МассивСотрудников = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(МассивФизическихЛиц, Истина, Организация, Дата).ВыгрузитьКолонку("Сотрудник");
	
	ДобавитьЛицевыеСчета(МассивСотрудников);
	
КонецПроцедуры

Процедура Рассчитать() Экспорт
	
	ВзаиморасчетыССотрудниками.ВедомостьРассчитать(ЭтотОбъект, МестоВыплаты());
	
КонецПроцедуры	

Процедура РассчитатьНалоги() Экспорт
	
	ВзаиморасчетыССотрудниками.ВедомостьРассчитатьНалоги(ЭтотОбъект, МестоВыплаты());
	МассивСотрудников = ЗарплатаПодробно.ВыгрузитьКолонку("Сотрудник");
	
	ДобавитьЛицевыеСчета(МассивСотрудников);
	
КонецПроцедуры	


// Подсистема "Управление доступом"

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическиеЛица.ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом"

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если Документы.ВедомостьНаВыплатуЗарплатыВБанк.ЭтоДанныеЗаполненияНезачисленнымиСтроками(ДанныеЗаполнения) Тогда
		ЗаполнитьНезачисленнымиСтроками(ДанныеЗаполнения)
	Иначе	
		ВзаиморасчетыССотрудниками.ВедомостьОбработкаЗаполнения(ЭтотОбъект,ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ВзаиморасчетыССотрудниками.ВедомостьОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты)	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВзаиморасчетыССотрудниками.ВедомостьПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи); 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ВзаиморасчетыССотрудниками.ВедомостьОбработкаПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция МестоВыплаты()
	
	МестоВыплаты = ВзаиморасчетыССотрудниками.ВедомостьМестоВыплаты();
	МестоВыплаты.Вид = Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект;
	МестоВыплаты.Значение = ЗарплатныйПроект; 
	
	Возврат МестоВыплаты
	
КонецФункции

// Заполняет документ на основании существующего,
// перенося в новый документ только указанных физических лиц
// 
// Параметры:
//	Документ - исходный документ (объект или ссылка)
//  Физлица - массив физических лиц
//
Процедура ЗаполнитьНезачисленнымиСтроками(ДанныеЗаполнения) Экспорт
	
	Реквизиты = Новый Массив;
	Для Каждого Реквизит Из ДанныеЗаполнения.Ведомость.Метаданные().Реквизиты Цикл
		Реквизиты.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	Шапка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения.Ведомость, Реквизиты);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка); 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Ведомость.Ссылка);
	Запрос.УстановитьПараметр("Физлица", ДанныеЗаполнения.Физлица);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВедомостьЗарплата.Сотрудник КАК Сотрудник,
	|	ВедомостьЗарплата.Подразделение КАК Подразделение,
	|	ВедомостьЗарплата.КВыплате КАК КВыплате,
	|	ВедомостьЗарплата.Авторасчет КАК Авторасчет,
	|	ВедомостьЗарплата.НомерЛицевогоСчета КАК НомерЛицевогоСчета
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьЗарплата
	|ГДЕ
	|	ВедомостьЗарплата.Ссылка = &Ссылка
	|	И ВедомостьЗарплата.Сотрудник.ФизическоеЛицо В(&Физлица)";
	
	НезачисленнаяЗарплата = Запрос.Выполнить().Выгрузить();
	
	Зарплата.Загрузить(НезачисленнаяЗарплата);
	
КонецПроцедуры

#КонецЕсли
