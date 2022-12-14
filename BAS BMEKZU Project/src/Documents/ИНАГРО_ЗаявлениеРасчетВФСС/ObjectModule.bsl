#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого Строка Из ДокументыПоНачислениям Цикл
		
		Если Строка.Документ.Дата >= Дата Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Дата в строке табличной части %1 больше даты документа %2';uk='Дата в рядку табличної частини %1 більша дати документу %2'"), Строка.НомерСтроки, Дата);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,ЭтотОбъект,,,Отказ);
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Перем Заголовок;	
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	
	Если НЕ Отказ Тогда
		
		РезультатЗапросаПоДокументам = СформироватьЗапросПоДокументамТабличнойЧасти();			
		ВыборкаПоДокументам = РезультатЗапросаПоДокументам.Выбрать();
		
		Пока ВыборкаПоДокументам.Следующий() Цикл
			
			ПроверитьЗаполнениеСтатьиРасчетовСФСС(ВыборкаПоДокументам, Отказ, Заголовок);
			
			Если Не Отказ Тогда
				ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоДокументам);	
			КонецЕсли;
			
		КонецЦикла; 
		
	КонецЕсли;		
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
КонецПроцедуры

#КонецОбласти 

#Область Проведение

Функция СформироватьЗапросПоДокументамТабличнойЧасти()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПериодРегистрации", ПериодРегистрации);
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	
	Если Дата >= Дата(2018,10,1) Тогда
		
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ОсновнойЗапрос.Документ КАК Документ,
			|	ОсновнойЗапрос.Сотрудник КАК Сотрудник,
			|	ОсновнойЗапрос.СчетУчета КАК СчетУчета,
			|	ОсновнойЗапрос.Результат КАК Результат,
			|	ОсновнойЗапрос.СтатьяРасчетовСФСС КАК СтатьяРасчетовСФСС
			|ИЗ
			|	(ВЫБРАТЬ
			|		Документы.Документ КАК Документ,
			|		Начисления.Сотрудник КАК Сотрудник,
			|		Начисления.ВидРасчета.СчетУчета КАК СчетУчета,
			|		Начисления.Результат КАК Результат,
			|		РазмерыВыплат.СтатьяРасчетовСФСС КАК СтатьяРасчетовСФСС
			|	ИЗ
			|		Документ.ИНАГРО_ЗаявлениеРасчетВФСС.Погребение КАК Документы
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ИНАГРО_Начисления КАК Начисления
			|			ПО Документы.Документ = Начисления.Регистратор
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РазмерыЗаконодательноУстановленныхВыплат.СрезПоследних(&ПериодРегистрации, ) КАК РазмерыВыплат
			|			ПО (Начисления.ВидРасчета = РазмерыВыплат.ВидРасчета)
			|	ГДЕ
			|		Документы.Ссылка = &ДокументСсылка
			|		И Начисления.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		Документы.Документ,
			|		Начисления.Сотрудник,
			|		Начисления.ВидРасчета.СчетУчета,
			|		Начисления.Результат,
			|		Документы.Документ.ПричинаНетрудоспособности.СтатьяРасчетовСФСС
			|	ИЗ
			|		Документ.ИНАГРО_ЗаявлениеРасчетВФСС.Больничные КАК Документы
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ИНАГРО_Начисления КАК Начисления
			|			ПО Документы.Документ = Начисления.Регистратор
			|	ГДЕ
			|		Документы.Ссылка = &ДокументСсылка
			|		И Начисления.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		Документы.Документ,
			|		Начисления.Сотрудник,
			|		Начисления.ВидРасчета.СчетУчета,
			|		Начисления.Результат,
			|		Документы.Документ.ПричинаНетрудоспособности.СтатьяРасчетовСФСС
			|	ИЗ
			|		Документ.ИНАГРО_ЗаявлениеРасчетВФСС.БольничныеНС КАК Документы
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ИНАГРО_Начисления КАК Начисления
			|			ПО Документы.Документ = Начисления.Регистратор
			|	ГДЕ
			|		Документы.Ссылка = &ДокументСсылка
			|		И Начисления.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		Документы.Документ,
			|		Начисления.Сотрудник,
			|		Начисления.ВидРасчета.СчетУчета,
			|		Начисления.Результат,
			|		Документы.Документ.ПричинаНетрудоспособности.СтатьяРасчетовСФСС
			|	ИЗ
			|		Документ.ИНАГРО_ЗаявлениеРасчетВФСС.Декретные КАК Документы
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ИНАГРО_Начисления КАК Начисления
			|			ПО Документы.Документ = Начисления.Регистратор
			|	ГДЕ
			|		Документы.Ссылка = &ДокументСсылка
			|		И Начисления.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА) КАК ОсновнойЗапрос";
			
	Иначе
		
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ОсновнойЗапрос.Документ КАК Документ,
			|	ОсновнойЗапрос.Сотрудник КАК Сотрудник,
			|	ОсновнойЗапрос.СчетУчета КАК СчетУчета,
			|	ОсновнойЗапрос.Результат КАК Результат,
			|	ОсновнойЗапрос.СтатьяРасчетовСФСС КАК СтатьяРасчетовСФСС
			|ИЗ
			|	(ВЫБРАТЬ
			|		Документы.Документ КАК Документ,
			|		Начисления.Сотрудник КАК Сотрудник,
			|		Начисления.ВидРасчета.СчетУчета КАК СчетУчета,
			|		Начисления.Результат КАК Результат,
			|		ЗНАЧЕНИЕ(Справочник.СтатьиНалоговыхДеклараций.ФССУтрТрудосп_Погребен) КАК СтатьяРасчетовСФСС
			|	ИЗ
			|		Документ.ИНАГРО_ЗаявлениеРасчетВФСС.ДокументыПоНачислениям КАК Документы
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ИНАГРО_Начисления КАК Начисления
			|			ПО Документы.Документ = Начисления.Регистратор
			|	ГДЕ
			|		Документы.Ссылка = &ДокументСсылка
			|		И Документы.Документ ССЫЛКА Документ.ИНАГРО_НачислениеЕдиновременныхПособийЗаСчетФСС
			|		И Начисления.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		Документы.Документ,
			|		Начисления.Сотрудник,
			|		Начисления.ВидРасчета.СчетУчета,
			|		Начисления.Результат,
			|		Документы.Документ.ПричинаНетрудоспособности.СтатьяРасчетовСФСС
			|	ИЗ
			|		Документ.ИНАГРО_ЗаявлениеРасчетВФСС.ДокументыПоНачислениям КАК Документы
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ИНАГРО_Начисления КАК Начисления
			|			ПО Документы.Документ = Начисления.Регистратор
			|	ГДЕ
			|		Документы.Ссылка = &ДокументСсылка
			|		И Документы.Документ ССЫЛКА Документ.ИНАГРО_НачислениеПоБольничномуЛисту
			|		И Начисления.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА) КАК ОсновнойЗапрос";
		
	КонецЕсли;
	
	Возврат Запрос.Выполнить();
	
КонецФункции

// Проверяет заполнена ли СтатьяРасчетовСФСС.
// Если реквизит не заполнен , то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//  							  из результата запроса по документам, 
//  Отказ 						- флаг отказа в проведении.
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтатьиРасчетовСФСС(ВыборкаПоТЧ, Отказ, Заголовок)
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоТЧ.СтатьяРасчетовСФСС) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В документе %1 не заполнена статья расчетов в ФСС';uk='В документі %1 не заповнена стаття ФСС'"), ВыборкаПоТЧ.Документ);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , , Отказ);
	КонецЕсли;
	
КонецПроцедуры

// По строке выборки результата запроса по документу формируем движения по регистрам.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                  - выборка из результата запроса по шапке документа
//  СтруктураПроведенияПоРегистрамНакопления - структура, содержащая имена регистров 
//                                             накопления по которым надо проводить документ
//  СтруктураПараметров                      - структура параметров проведения.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоТЧ)
	
	Движения.ИНАГРО_ВзаиморасчетыПоНачислениямЗаСчетФСС.Записывать = Истина;
	Движение = Движения.ИНАГРО_ВзаиморасчетыПоНачислениямЗаСчетФСС.Добавить();
	
	// Свойства
	Движение.Период                 = Дата;
	Движение.ВидДвижения			= ВидДвиженияНакопления.Приход;
	
	// Измерения
	Движение.Организация			= Организация;
	Движение.ПериодВзаиморасчетов	= НачалоМесяца(ПериодРегистрации);
	Движение.СтатьяРасчетовСФСС     = ВыборкаПоТЧ.СтатьяРасчетовСФСС;
	Движение.Сотрудник              = ВыборкаПоТЧ.Сотрудник;
	Движение.СчетУчета			    = ВыборкаПоТЧ.СчетУчета;
	
	// Ресурсы
	Движение.Сумма					= ВыборкаПоТЧ.Результат; 
	
	// Реквизиты
	Движение.Документ 				= ВыборкаПоТЧ.Документ;
	Движение.КодОперации			= Перечисления.ИНАГРО_КодыОперацийРасчетыСФСС.Начислено;
		
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции	

Процедура ЗаполнитьПоДокументуОснованию(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ИНАГРО_НачислениеПоБольничномуЛисту") И Основание.Дата >= Дата(2018,10,1) Тогда 

		Дата = ТекущаяДата();
		ПериодРегистрации = Основание.ПериодРегистрации;
		Организация = Основание.Организация;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	НачислениеПоБольничномуЛисту.Ссылка.ПричинаНетрудоспособности.СтатьяРасчетовСФСС КАК Статья,
		|	НачислениеПоБольничномуЛисту.Ссылка.ПричинаНетрудоспособности КАК ПричинаНетрудоспособности,
		|	НачислениеПоБольничномуЛисту.Ссылка КАК Документ,
		|	НачислениеПоБольничномуЛисту.Сотрудник КАК Сотрудник,
		|	СУММА(НачислениеПоБольничномуЛисту.ОплаченоДнейЧасов) КАК Дни,
		|	СУММА(НачислениеПоБольничномуЛисту.Результат) КАК Сумма,
		|	НачислениеПоБольничномуЛисту.ВидРасчета
		|ИЗ
		|	Документ.ИНАГРО_НачислениеПоБольничномуЛисту.Начисления КАК НачислениеПоБольничномуЛисту
		|ГДЕ
		|	НачислениеПоБольничномуЛисту.Ссылка = &Ссылка
		|	И НачислениеПоБольничномуЛисту.Результат > 0
		|	И НачислениеПоБольничномуЛисту.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА
		|
		|СГРУППИРОВАТЬ ПО
		|	НачислениеПоБольничномуЛисту.Ссылка.ПричинаНетрудоспособности.СтатьяРасчетовСФСС,
		|	НачислениеПоБольничномуЛисту.Ссылка.ПричинаНетрудоспособности,
		|	НачислениеПоБольничномуЛисту.Ссылка,
		|	НачислениеПоБольничномуЛисту.Сотрудник,
		|	НачислениеПоБольничномуЛисту.ВидРасчета";
		
		Запрос.УстановитьПараметр("Ссылка", Основание );
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			Если Выборка.Статья = Справочники.СтатьиНалоговыхДеклараций.ФССНесчСлуч_ВремНетрудосп Тогда
				НоваяСтрока = БольничныеНС.Добавить();
			ИначеЕсли Выборка.ВидРасчета = ПланыВидовРасчета.ИНАГРО_Начисления.ОплатаПоСреднемуБЛПоБеременностиИРодам Тогда
				НоваяСтрока = Декретные.Добавить();
			Иначе
				НоваяСтрока = Больничные.Добавить();
			КонецЕсли;
			Сотрудник = Выборка.Сотрудник;
			Сумма = Выборка.Сумма;
			Дни = Выборка.Дни;
		Иначе 
			ТестСообщения = НСтр("ru='Нет данных для создания заявления-расчета в ФСС!';uk='Відсутні дані для створення заяви-розрахунку в ФСС!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТестСообщения); 
			Возврат;	
		КонецЕсли;
		
		НоваяСтрока.Документ = Основание;
		НоваяСтрока.Сотрудник = Сотрудник;
		НоваяСтрока.Сумма = Сумма;
		НоваяСтрока.Дни = Дни;
		Ответственный = Основание.Ответственный;
		РежимЗаполнения = ?(Основание.ЭлектронныйБольничный,1,2);
		Записать();
		Документы.ИНАГРО_ЗаявлениеРасчетВФСС.РассчитатьИтоговыеСуммы(ЭтотОбъект);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ИНАГРО_НачислениеЕдиновременныхПособийЗаСчетФСС") И Основание.Дата >= Дата(2018,10,1) Тогда 
		
		Дата = ТекущаяДата();
		ПериодРегистрации = Основание.ПериодРегистрации;
		Организация = Основание.Организация;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	НачислениеЕдиновременныхПособийЗаСчетФСС.Ссылка КАК Документ,
			|	НачислениеЕдиновременныхПособийЗаСчетФСС.Сотрудник КАК Сотрудник,
			|	СУММА(НачислениеЕдиновременныхПособийЗаСчетФСС.Результат) КАК Сумма,
			|	НачислениеЕдиновременныхПособийЗаСчетФСС.ВидРасчета КАК ВидРасчета
			|ИЗ
			|	Документ.ИНАГРО_НачислениеЕдиновременныхПособийЗаСчетФСС.Начисления КАК НачислениеЕдиновременныхПособийЗаСчетФСС
			|ГДЕ
			|	НачислениеЕдиновременныхПособийЗаСчетФСС.Ссылка = &Ссылка
			|	И НачислениеЕдиновременныхПособийЗаСчетФСС.Результат > 0
			|	И НачислениеЕдиновременныхПособийЗаСчетФСС.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА
			|
			|СГРУППИРОВАТЬ ПО
			|	НачислениеЕдиновременныхПособийЗаСчетФСС.Ссылка,
			|	НачислениеЕдиновременныхПособийЗаСчетФСС.Сотрудник,
			|	НачислениеЕдиновременныхПособийЗаСчетФСС.ВидРасчета";
		
		Запрос.УстановитьПараметр("Ссылка", Основание );
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			НоваяСтрока = Погребение.Добавить();
			Сотрудник = Выборка.Сотрудник;
			Сумма = Выборка.Сумма;
		Иначе 
			ТестСообщения = НСтр("ru='Нет данных для создания заявления-расчета в ФСС!';uk='Відсутні дані для створення заяви-розрахунку в ФСС!'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТестСообщения); 
			Возврат;	
		КонецЕсли;
		
		НоваяСтрока.Документ = Основание;
		НоваяСтрока.Сотрудник = Сотрудник;
		НоваяСтрока.Сумма = Сумма;
		Ответственный = Основание.Ответственный;
		Записать();
		Документы.ИНАГРО_ЗаявлениеРасчетВФСС.РассчитатьИтоговыеСуммы(ЭтотОбъект);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ИНАГРО_НачислениеПоБольничномуЛисту") ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.ИНАГРО_НачислениеЕдиновременныхПособийЗаСчетФСС") Тогда  	
		
		Дата = ТекущаяДата();
		ПериодРегистрации = Основание.ПериодРегистрации;
		Организация = Основание.Организация;
	
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ИНАГРО_НачислениеПоБольничномуЛисту") Тогда
			
			Запрос = Новый Запрос;
			
			Запрос.Текст =
				"ВЫБРАТЬ
				|	НачислениеПоБольничномуЛисту.Ссылка.ПричинаНетрудоспособности.СтатьяРасчетовСФСС КАК Статья
				|ИЗ
				|	Документ.ИНАГРО_НачислениеПоБольничномуЛисту.Начисления КАК НачислениеПоБольничномуЛисту
				|ГДЕ
				|	НачислениеПоБольничномуЛисту.Ссылка = &Ссылка
				|	И НачислениеПоБольничномуЛисту.Результат > 0
				|	И НачислениеПоБольничномуЛисту.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА";
			
			Запрос.УстановитьПараметр("Ссылка", Основание);		
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Выборка.Следующий() Тогда
				Если  Выборка.Статья = Справочники.СтатьиНалоговыхДеклараций.ФССНесчСлуч_ВремНетрудосп Тогда
					ЗаСчетФССОтНС = Истина;
				Иначе
					ЗаСчетФССОтНС = Ложь;
				КонецЕсли;
			Иначе				
				ТестСообщения = НСтр("ru='Нет данных для создания заявления-расчета в ФСС!';uk='Відсутні дані для створення заяви-розрахунку в ФСС!'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТестСообщения); 
				Возврат;	
			КонецЕсли;
		КонецЕсли;
		
		НоваяСтрока = ДокументыПоНачислениям.Добавить();
		НоваяСтрока.Документ = Основание;
		
		Ответственный = Основание.Ответственный;
		
		// Необходимо записать документ, для правильного расчета итоговых сумм.
		Записать();
		
		Документы.ИНАГРО_ЗаявлениеРасчетВФСС.РассчитатьИтоговыеСуммы(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
