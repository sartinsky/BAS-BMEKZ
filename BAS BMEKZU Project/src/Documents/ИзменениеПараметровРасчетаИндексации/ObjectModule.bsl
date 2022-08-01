#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	

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
 
 	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	СтруктураДанныхОбИндексации = Новый Структура;
	СтруктураДанныхОбИндексации.Вставить("ДанныеОбИндексации", ДанныеДляПроведения.ДанныеОбИндексации);
	
	РасчетЗарплаты.СформироватьДвиженияПараметровРасчетаИндексации(ЭтотОбъект, Движения, СтруктураДанныхОбИндексации);

 
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры // ОбработкаЗаполнения()


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Регистратор", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("Сотрудник", ЭтотОбъект.Сотрудник);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзменениеПараметровРасчетаИндексации.ДатаИзменения КАК ДатаСобытия,
	|	ИзменениеПараметровРасчетаИндексации.Сотрудник КАК Сотрудник,
	|	ИзменениеПараметровРасчетаИндексации.Организация КАК Организация,
	|	ИзменениеПараметровРасчетаИндексации.Подразделение КАК Подразделение,
	|	ИзменениеПараметровРасчетаИндексации.Должность КАК Должность,
	|	ИзменениеПараметровРасчетаИндексации.ФиксированнаяИндексация КАК ФиксированнаяИндексация,
	|	1 КАК Коэффициент 
	|ИЗ
	|	Документ.ИзменениеПараметровРасчетаИндексации КАК ИзменениеПараметровРасчетаИндексации
	|ГДЕ
	|	ИзменениеПараметровРасчетаИндексации.Ссылка = &Регистратор";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПроведения = Новый Структура; 
	
	// Второй набор данных для проведения - таблица для формирования плановых начислений
	ДанныеДляПроведения.Вставить("ДанныеОбИндексации", РезультатЗапроса.Выгрузить());
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.КадровыйПеревод") Тогда
		
		ДокументОснование = Основание;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДатаСобытия",ДокументОснование.ДатаНачала);
		Запрос.УстановитьПараметр("Сотрудник",ДокументОснование.Сотрудник);
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КадроваяИсторияСотрудниковСрезПоследних.Подразделение,
		|	КадроваяИсторияСотрудниковСрезПоследних.Должность
		|ИЗ
		|	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&ДатаСобытия, Сотрудник = &Сотрудник) КАК КадроваяИсторияСотрудниковСрезПоследних";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Сотрудник = ДокументОснование.Сотрудник;
			ДатаИзменения = ДокументОснование.ДатаНачала;
			Подразделение = Выборка.Подразделение;
			Должность = Выборка.Должность;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры	// ЗаполнитьПоДокументуОснованию


#КонецЕсли