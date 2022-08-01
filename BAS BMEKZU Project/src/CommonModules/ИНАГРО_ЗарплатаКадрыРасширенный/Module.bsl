#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииПоказателейРасчета

// Получает информацию о показателях расчета зарплаты.
//
// Параметры:
//	- Показатели - массив показателей расчета зарплаты.
//
// Возвращаемое значение - соответствие, ключ - показатель, 
//	значение - структура сведений о показателе с полями:
//	- СпособВвода - способ ввода показателя (Перечисление СпособыВводаЗначенийПоказателейРасчетаЗарплаты).
//	- ТипПоказателя - Описание типов. "Настоящий" тип показателя, используемый при вводе 
//							значений показателя в кадровых документах, штатном расписании и других 
//							документах ввода значений.
//	- ТипПоказателяПриРасчете - Описание типов. Тип при вводе/редактировании числовых 
//								значения показателя в документах начисления.
//	- Валюта
//	- ЗначениеРассчитываетсяАвтоматически
//	- СпособПримененияЗначений
//	- СпособВводаЗначений
//	- Наименование
//	- ОтображатьВДокументахНачисления
//
Функция СведенияОПоказателяхРасчетаЗарплаты(Показатели) Экспорт
	
	ИменаРеквизитов = 
	"Идентификатор,
	|ВидПоказателя,
	|ВозможностьИзменения,
	|ТипПоказателя,
	|Наименование,
	|НеИспользуется";
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Показатели, ИменаРеквизитов);
	
	СведенияОПоказателях = Новый Соответствие;
	
	СтажевыеПоказатели = Новый Массив;
	
	Для Каждого КлючИЗначение Из ЗначенияРеквизитов Цикл
		СведенияОПоказателе = КлючИЗначение.Значение;
		СведенияОПоказателе.Вставить("ЭтоШкалаОценки", СведенияОПоказателе.ТипПоказателя = Перечисления.ИНАГРО_ТипыПоказателейСхемМотивации.ЧисловойЗависящийОтДругогоПоказателя);
		СведенияОПоказателе.Вставить("ЭтоПоказательЗависящийОтСтажа", СведенияОПоказателе.ТипПоказателя = Перечисления.ИНАГРО_ТипыПоказателейСхемМотивации.ЧисловойЗависящийОтСтажа);
		СведенияОПоказателе.ТипПоказателя = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3));
		СведенияОПоказателе.Вставить("ЗначениеПоУмолчанию", 0);
		СведенияОПоказателе.Вставить("ТипПоказателяПриРасчете", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3)));
		Если СведенияОПоказателе.ЭтоПоказательЗависящийОтСтажа Тогда
			СтажевыеПоказатели.Добавить(КлючИЗначение.Ключ);
			СведенияОПоказателе.Вставить("МаксимальноеЗначение");
		КонецЕсли; 
		СведенияОПоказателях.Вставить(КлючИЗначение.Ключ, СведенияОПоказателе);
	КонецЦикла;
	
	Если СтажевыеПоказатели.Количество() > 0 Тогда
		ЗначенияСтажевыхПоказателей = ДанныеСтажевыхПоказателей(СтажевыеПоказатели);
		Для Каждого ОписаниеПоказателя Из ЗначенияСтажевыхПоказателей Цикл
			СведенияОПоказателе = СведенияОПоказателях.Получить(ОписаниеПоказателя.Показатель);
			СведенияОПоказателе.Вставить("ВидСтажа", ОписаниеПоказателя.ВидСтажа);
			СведенияОПоказателе.Вставить("МаксимальноеЗначение", ОписаниеПоказателя.Значение);
			СведенияОПоказателях.Вставить(ОписаниеПоказателя.Показатель, СведенияОПоказателе);
		КонецЦикла;
	КонецЕсли; 
	
	Возврат СведенияОПоказателях;
	
КонецФункции

// В табличной части вида расчета находит показатели в соответствии с указанными идентификаторами 
//	и отмечает их как запрашиваемые при вводе.
//
// Параметры:
//	ВидРасчетаОбъект - ПланВидовРасчетаОбъект.Начисления, ПланВидовРасчетаОбъект.Удержания
//	ИдентификаторыПоказателей - массив идентификаторов показателей.
//
Процедура ОтметитьЗапрашиваемыеПоказатели(ВидРасчетаОбъект, ИдентификаторыПоказателей) Экспорт
	
	ОтметитьПоказатели(ВидРасчетаОбъект, ИдентификаторыПоказателей, "ЗапрашиватьПриВводе");
	
КонецПроцедуры

Процедура ЗаполнитьПоказателиПредопределенногоСпособаРасчета(СпособРасчета, ТаблицаПоказателей) Экспорт
	
	Если ИНАГРО_РасчетЗарплатыРасширенныйКлиентСервер.СпособРасчетаИспользуетФормулу(СпособРасчета) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаПоказателей.Очистить();
	
	Показатели = ИНАГРО_РасчетЗарплатыРасширенный.ПоказателиПредопределенногоСпособаРасчета(СпособРасчета);
	
	Для Каждого Показатель Из Показатели Цикл
		НоваяСтрока = ТаблицаПоказателей.Добавить();
		НоваяСтрока.Показатель = Показатель;
		НоваяСтрока.ИспользоватьПриРасчете = Истина;
	КонецЦикла;

КонецПроцедуры

// Данная процедура написана компанией ИН-АГРО.
// 
Процедура ЗаполнитьФизЛицо(Документ, ИмяСотрудник = "Сотрудник", ИмяФизЛицо = "ФизЛицо") Экспорт
	
	Если ЗначениеЗаполнено(Документ[ИмяФизЛицо]) И НЕ ЗначениеЗаполнено(Документ[ИмяСотрудник]) Тогда
		Возврат;
	КонецЕсли;	
	Документ[ИмяФизЛицо]= Документ[ИмяСотрудник].ФизическоеЛицо;
    	
КонецПроцедуры

// Удаляет начисления по работнику, все или автоматически заполняемые
// Параметры:
//   Сотрудник - СправочникСсылка.ФизическиеЛица
//   УдалятьВсе - булево, если Истина - удаляются все начисления по физическому лицу,
//				например, при его удалении из списка.
//				Если Ложь - удаляются только те, которые вводятся "автоматически",
//				например, при редактировании данных по строке табличной части 
//				со списком работников
Процедура УдалитьПараметрыРасчетаПоРаботнику(Сотрудник, ИмяТабЧасти, Объект) Экспорт
	
	СтруктураПоиска = Новый Структура("Сотрудник", Сотрудник);
	
	Строки = Объект[ИмяТабЧасти].НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаТабличнойЧасти Из Строки Цикл
		Объект[ИмяТабЧасти].Удалить(СтрокаТабличнойЧасти);
	КонецЦикла;
	
КонецПроцедуры

// Функция возвращает совокупность данных о физическом лице в виде структуры,
// В совокупность данных входит ФИО, должность в заданной организации,
// паспортные данные и др.
//
// Параметры:
//  Организация  - СправочникСсылка.Организации - организация, по которой
//                 определяется должность и подразделение работника
//  ФизЛицо      - СправочникСсылка.ФизическиеЛица - физическое лицо,
//                 по которому возвращается совокупность данных
//  ДатаСреза    - Дата - дата, на которую считываются данные
//  ФИОКратко    - Булево - если Истина (по умолчанию), 
//  Представление физ.лица включает фамилию и инициалы, если Ложь - фамилию и полностью имя и отчество
//
// Возвращаемое значение:
//  Структура    - Структура с совокупностью данных о физическом лице:
//                 - Фамилия
//                 - Имя
//                 - Отчество
//                 - Представление (Фамилия И.О.)
//                 - Подразделение
//                 - ВидДокумента
//                 - Серия
//                 - Номер
//                 - ДатаВыдачи
//                 - КемВыдан
//                 - КодПодразделения
//
Функция ДанныеФизЛица(Организация, ФизическоеЛицо, ДатаСреза) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РаботникиОрганизаций.Сотрудник КАК Сотрудник,
		|	РаботникиОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
		|	РаботникиОрганизаций.Должность КАК Должность,
		|	РаботникиОрганизаций.Сотрудник.ИНАГРО_ТабельныйНомер КАК ТабельныйНомер
		|ИЗ
		|	РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(
		|			&ДатаСреза,
		|			Организация = &Организация
		|				И Сотрудник.ФизическоеЛицо = &ФизическоеЛицо) КАК РаботникиОрганизаций
		|ГДЕ
		|	РаботникиОрганизаций.ЗанимаемыхСтавок > 0";
	
	Запрос.УстановитьПараметр("Организация",    Организация);
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.УстановитьПараметр("ДатаСреза",      ДатаСреза);
	
	КадровыеДанныеСотрудников = Запрос.Выполнить().Выгрузить();
	
	Результат = Новый Структура("Сотрудник, ПодразделениеОрганизации, Должность, ТабельныйНомер");	
	
	ДанныеФизическогоЛица = УчетЗарплаты.ДанныеФизическихЛиц(Организация, ФизическоеЛицо, ДатаСреза, Истина);
	
	Результат.Вставить("Фамилия",       ДанныеФизическогоЛица.Фамилия);
	Результат.Вставить("Имя",           ДанныеФизическогоЛица.Имя);
	Результат.Вставить("Отчество",      ДанныеФизическогоЛица.Отчество);
	Результат.Вставить("Представление", ДанныеФизическогоЛица.Представление);
	
	Если КадровыеДанныеСотрудников.Количество() > 0 Тогда		
		ЗаполнитьЗначенияСвойств(Результат, КадровыеДанныеСотрудников[0]);				
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОтметитьПоказатели(ВидРасчетаОбъект, ИдентификаторыПоказателей, ИмяСвойства)
	
	Если ИдентификаторыПоказателей = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПредопределенныеПоказатели = ИНАГРО_ЗарплатаКадрыРасширенныйПовтИсп.ИменаПредопределенныхПоказателей();
	
	Для Каждого ИдентификаторПоказателя Из ИдентификаторыПоказателей Цикл
		
		Если ПредопределенныеПоказатели.Найти(ИдентификаторПоказателя) <> Неопределено Тогда 
			ПоказательСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ИНАГРО_ПоказателиСхемМотивации." + ИдентификаторПоказателя);
		Иначе 
			ПоказательСсылка = ИНАГРО_РасчетЗарплатыРасширенный.ПоказательПоИдентификатору(ИдентификаторПоказателя);
		КонецЕсли;
		
		НайденныеСтроки = ВидРасчетаОбъект.Показатели.НайтиСтроки(Новый Структура("Показатель", ПоказательСсылка));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока[ИмяСвойства] = Истина;
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

Функция ДанныеСтажевыхПоказателей(Показатели)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Показатели", Показатели);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПоказателиРасчетаЗарплаты.Ссылка КАК Показатель,
		|	ПоказателиРасчетаЗарплаты.ВидСтажа КАК ВидСтажа,
		|	МАКСИМУМ(ЕСТЬNULL(ПоказателиРасчетаЗарплатыШкалаОценкиСтажа.ЗначениеПоказателя, 0)) КАК Значение
		|ИЗ
		|	Справочник.ИНАГРО_ПоказателиСхемМотивации КАК ПоказателиРасчетаЗарплаты
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ИНАГРО_ПоказателиСхемМотивации.ШкалаОценкиСтажа КАК ПоказателиРасчетаЗарплатыШкалаОценкиСтажа
		|		ПО ПоказателиРасчетаЗарплаты.Ссылка = ПоказателиРасчетаЗарплатыШкалаОценкиСтажа.Ссылка
		|ГДЕ
		|	ПоказателиРасчетаЗарплаты.Ссылка В(&Показатели)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоказателиРасчетаЗарплаты.Ссылка,
		|	ПоказателиРасчетаЗарплаты.ВидСтажа";
		
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает таблицу значений заполненную данными сотрудников, перечисленными в 
// параметре СписокНеобходимыхДанных
//
// Параметры
//	ТолькоРазрешенные - Булево
//  СписокСотрудников - Массив ссылок на элементы справочника сотрудники или
//						  СправочникСсылка.Сотрудники
//  КадровыеДанные - 	Строка - список полей данных, перечисленных через запятую 
//						или Массив строк с полями данных,
//						которые необходимо получить. Ниже приведены идентификаторы 
//						получаемых данных и описание значения, которое будет возвращено в 
//						таблице значений
//						которые необходимо получить. Ниже приведены идентификаторы 
//						получаемых данных и описание значения, которое будет возвращено в 
//						таблице значений
//
//	ДатаПолученияДанных	- дата на которую необходимо получить данные сотрудников, 
//						применимо к данным, носящим периодический характер
//						Если дату не указывать, будут получены самые последние данные.
//
//
//  ПоляОтбораПериодическихДанных - Структура, в качестве ключа указывается имя таблицы, содержащей
//									периодические данные (например ФИОФизическихЛиц, ГражданствоФизическихЛиц)
//									В качестве значений коллекция условий отбора, 
//									соединяемых по "И" и применяемых к регистру сведений
//									Коллекция строки которой имеют поля
//										ЛевоеЗначение - строка, имя поля регистра сведений
//										ВидСравнения - строка, вид сравнения, допустимый в языке запросов
//										ПравоеЗначение - значение для сравнения с полем ЛевоеЗначение
//
//	Список полей, допустимых в параметре КадровыеДанные
//
//			Все имена полей, которые поддерживаются процедурой КадровыеДанныеФизическихЛиц, для
//			получения кадровых данных физического лица. Исключения составляют стандартные реквизиты
//			справочника ФизическиеЛица - Код и Наименование. Для их получения необходимо задать имена 
//			полей ФизическоеЛицоКод и ФизическоеЛицоНаименование, соответственно.
//
//			- Все имена реквизитов справочника Сотрудники
//			- ТабельныйНомер - строка
//			- Организация
//			- Подразделение
//			- Должность
//			- ТарифнаяСтавка - число
//			- ФОТ - число
//			- КоличествоСтавок - число
//			- ОсновноеРабочееМестоВОрганизации - булево
//			- РаботаетВСтуденческомОтряде - булево
//			- ЯвляетсяВоеннослужащим - булево
//			- ЯвляетсяПрокурором - булево
//			- ЯвляетсяФармацевтом - булево
//			- ЯвляетсяЧленомЛетногоЭкипажа - булево
//			- ЯвляетсяШахтером - булево
//			- ЯвляетсяРаботникомСДосрочнойПенсией - булево
//
// Возвращаемое значение:
//   ТаблицаЗначений   - Таблица значений, содержащая запрошенные данные
//
Функция КадровыеДанныеСотрудников(ТолькоРазрешенные, СписокСотрудников, КадровыеДанные, ДатаПолученияДанных = '00010101', ПоляОтбораПериодическихДанных = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	СправочникСотрудники.Ссылка КАК Сотрудник,
	               |	СправочникСотрудники.ВерсияДанных,
	               |	СправочникСотрудники.ПометкаУдаления,
	               |	СправочникСотрудники.Предопределенный,
	               |	СправочникСотрудники.Код,
	               |	СправочникСотрудники.Наименование,
	               |	СправочникСотрудники.ФизическоеЛицо,
	               |	СправочникСотрудники.ГоловнаяОрганизация КАК Организация,
	               |	СправочникСотрудники.ВАрхиве,
	               |	СправочникСотрудники.УточнениеНаименования,
	               |	СправочникСотрудники.ИНАГРО_ВидЗанятости КАК ТекущийВидЗанятости,
	               |	СправочникСотрудники.ГоловнаяОрганизация КАК ТекущаяОрганизация,
	               |	ВЫБОР
	               |		КОГДА Прием.ГПХ = 1
	               |			ТОГДА Прием.ПодразделениеОрганизации
	               |		ИНАЧЕ ТекущееМестоРаботы.ПодразделениеОрганизации
	               |	КОНЕЦ КАК ТекущееПодразделение,
	               |	ВЫБОР
	               |		КОГДА Прием.ГПХ = 1
	               |			ТОГДА Прием.ПодразделениеОрганизации
	               |		ИНАЧЕ ТекущееМестоРаботы.ПодразделениеОрганизации
	               |	КОНЕЦ КАК Подразделение,
	               |	ЕСТЬNULL(ТекущееМестоРаботы.Должность, ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)) КАК ТекущаяДолжность,
	               |	ЕСТЬNULL(ТекущееМестоРаботы.Должность, ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)) КАК Должность,
	               |	ТекущееМестоРаботы.Период КАК ДатаСобытия,
	               |	ЕСТЬNULL(Прием.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ДатаПриема,
	               |	ЕСТЬNULL(Увольнение.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ДатаУвольнения,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(Прием.Период, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК ОформленПриемНаРаботу,
	               |	Прием.Регистратор КАК ПриказОПриеме
	               |ИЗ
	               |	Справочник.Сотрудники КАК СправочникСотрудники
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(, Сотрудник В (&СписокСотрудников)) КАК ТекущееМестоРаботы
	               |		ПО (ТекущееМестоРаботы.Сотрудник = СправочникСотрудники.Ссылка)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ИНАГРО_РаботникиОрганизацийСрезПоследних.Сотрудник КАК Сотрудник,
	               |			ИНАГРО_РаботникиОрганизацийСрезПоследних.Организация КАК Организация,
	               |			ИНАГРО_РаботникиОрганизацийСрезПоследних.Период КАК Период,
	               |			ИНАГРО_РаботникиОрганизацийСрезПоследних.Регистратор КАК Регистратор,
	               |			0 КАК ГПХ,
	               |			ИНАГРО_РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизации КАК ПодразделениеОрганизации
	               |		ИЗ
	               |			РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(
	               |					&Дата,
	               |					ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу)
	               |						И Сотрудник В (&СписокСотрудников)) КАК ИНАГРО_РаботникиОрганизацийСрезПоследних
	               |		
	               |		ОБЪЕДИНИТЬ ВСЕ
	               |		
	               |		ВЫБРАТЬ
	               |			ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних.Сотрудник,
	               |			ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних.Организация,
	               |			ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних.Период,
	               |			ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних.Регистратор,
	               |			1,
	               |			ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних.ДокументОснование.ПодразделениеОрганизации
	               |		ИЗ
	               |			РегистрСведений.ИНАГРО_ПлановыеНачисленияРаботниковОрганизаций.СрезПоследних(
	               |					&Дата,
	               |					Действует
	               |						И Сотрудник В (&СписокСотрудников)
	               |						И ДокументОснование ССЫЛКА Документ.ИНАГРО_ДоговорНаВыполнениеРаботСФизЛицом
	               |						И НЕ ДокументОснование = ЗНАЧЕНИЕ(Документ.ИНАГРО_ДоговорНаВыполнениеРаботСФизЛицом.ПустаяСсылка)) КАК ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних) КАК Прием
	               |		ПО СправочникСотрудники.Ссылка = Прием.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ИНАГРО_РаботникиОрганизацийСрезПоследних.Сотрудник КАК Сотрудник,
	               |			ИНАГРО_РаботникиОрганизацийСрезПоследних.Организация КАК Организация,
	               |			ИНАГРО_РаботникиОрганизацийСрезПоследних.Период КАК Период
	               |		ИЗ
	               |			РегистрСведений.ИНАГРО_РаботникиОрганизаций.СрезПоследних(
	               |					&Дата,
	               |					ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	               |						И Сотрудник В (&СписокСотрудников)) КАК ИНАГРО_РаботникиОрганизацийСрезПоследних
	               |		
	               |		ОБЪЕДИНИТЬ ВСЕ
	               |		
	               |		ВЫБРАТЬ
	               |			ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних.Сотрудник,
	               |			ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних.Организация,
	               |			ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних.Период
	               |		ИЗ
	               |			РегистрСведений.ИНАГРО_ПлановыеНачисленияРаботниковОрганизаций.СрезПоследних(
	               |					&Дата,
	               |					НЕ ДокументОснование = ЗНАЧЕНИЕ(Документ.ИНАГРО_ДоговорНаВыполнениеРаботСФизЛицом.ПустаяСсылка)
	               |						И Сотрудник В (&СписокСотрудников)) КАК ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних
	               |		ГДЕ
	               |			НЕ ИНАГРО_ПлановыеНачисленияРаботниковОрганизацийСрезПоследних.Действует) КАК Увольнение
	               |		ПО СправочникСотрудники.Ссылка = Увольнение.Сотрудник
	               |ГДЕ
	               |	СправочникСотрудники.Ссылка В(&СписокСотрудников)";
	
	Запрос.УстановитьПараметр("СписокСотрудников", СписокСотрудников);
	Запрос.УстановитьПараметр("Дата", ДатаПолученияДанных);
	
	КадровыеДанныеСотрудников = Запрос.Выполнить().Выгрузить();
	
	Возврат КадровыеДанныеСотрудников;
	
КонецФункции

#КонецОбласти