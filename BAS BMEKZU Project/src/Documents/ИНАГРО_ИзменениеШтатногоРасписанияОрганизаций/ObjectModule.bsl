#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Структура, содержащая имена регистров сведений по которым надо проводить документ.
	Перем СтруктураПроведенияПоРегистрамСведений;
	
    РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		// Движения стоит добавлять, если в проведении еще не отказано (отказ = ложь)
		Если НЕ Отказ Тогда

			// Создадим и заполним структуры, содержащие имена регистров, по которым в зависимости от типа учета
			// проводится документ. В дальнейшем будем считать, что если для регистра не создан ключ в структуре,
			// то проводить по нему не надо.
			ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений);

			РезультатЗапросаПоШтатныеЕдиницы = СформироватьЗапросПоШтатныеЕдиницы(Режим);
		    РезультатЗапросаПоНадбавки = СформироватьЗапросПоНадбавки(Режим);

			// В циклах по строкам табличных частей будем добавлять информацию в движения регистров.
	        ВыборкаПоШтатныеЕдиницы = РезультатЗапросаПоШтатныеЕдиницы.Выбрать();
	        Пока ВыборкаПоШтатныеЕдиницы.Следующий() Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиШтатнойЕдиницы(ВыборкаПоШапкеДокумента, ВыборкаПоШтатныеЕдиницы, Отказ);

				// Движения стоит записывать, если в проведении еще не отказано (отказ =ложь)
				Если Не Отказ Тогда
					ДобавитьСтрокуВШтатноеРасписание(ВыборкаПоШапкеДокумента, ВыборкаПоШтатныеЕдиницы, СтруктураПроведенияПоРегистрамСведений);
				КонецЕсли;

			КонецЦикла;
			
	        ВыборкаПоНадбавки = РезультатЗапросаПоНадбавки.Выбрать();
	        Пока ВыборкаПоНадбавки.Следующий() Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиНадбавок(ВыборкаПоШапкеДокумента, ВыборкаПоНадбавки, Отказ);

				// Движения стоит записывать, если в проведении еще не отказано (отказ =ложь)
				Если Не Отказ Тогда
					ДобавитьСтрокуНадбавок(ВыборкаПоШапкеДокумента, ВыборкаПоНадбавки, СтруктураПроведенияПоРегистрамСведений);
				КонецЕсли;

			КонецЦикла;
		
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции	

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);

	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	Дата, 
	|	Организация,
	| 	Ссылка 
	|ИЗ 
	|	Документ." + Метаданные().Имя + "
	|ГДЕ 
	|	Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить();

КонецФункции

// Формирует запрос по таблице "Штатные единицы" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШтатныеЕдиницы(Режим)
	 
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДатаДока", Дата);
	Запрос.УстановитьПараметр("ДатаДока1", Дата + 1);
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);

	// Описание текста запроса:
	// Первая часть запроса  - вид строки запроса "ДанныеДляДвижений": 
	// 1. Выборка "СтрокиДокумента": 
	//		Выбираются строки документа.  
	// 2. Выборка "ПересекающиесяСтроки": 
	//		Среди остальных строк документа ищем строки с одинаковым значением 
    //      реквизитов "Подразделение" и "Должность"
	// 3. Выборка "ШтатноеРасписание": 
    //      Из регистра сведений выбираем сведения об изменяемых штатных единицах.
    //

	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтрокиДокумента.НомерСтроки КАК НомерСтроки,
		|	СтрокиДокумента.Подразделение КАК Подразделение,
		|	СтрокиДокумента.Должность КАК Должность,
		|	СтрокиДокумента.КоличествоСтавок КАК КоличествоСтавок,
		|	СтрокиДокумента.СозданоНовыхРабочихМест КАК СозданоНовыхРабочихМест,
		|	СтрокиДокумента.МинимальнаяТарифнаяСтавка КАК МинимальнаяТарифнаяСтавка,
		|	СтрокиДокумента.МаксимальнаяТарифнаяСтавка КАК МаксимальнаяТарифнаяСтавка,
		|	СтрокиДокумента.ВидТарифнойСтавки КАК ВидТарифнойСтавки,
		|	СтрокиДокумента.ГрафикРаботы КАК ГрафикРаботы,
		|	СтрокиДокумента.СпособОтраженияВБухучете КАК СпособОтраженияВБухучете,
		|	СтрокиДокумента.ОсновноеНачисление КАК ОсновноеНачисление,
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.Подразделение.Владелец <> &Организация
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОшибкаПодразделениеНеПринадлежитОрганизации,
		|	МИНИМУМ(ПересекающиесяСтроки.НомерСтроки) КАК КонфликтнаяСтрока,
		|	ВложенныйЗапрос.КоличествоСтавок КАК БылоСтавок,
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаДока, ДЕНЬ)
		|			ТОГДА ВложенныйЗапрос.Регистратор.Представление
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК НайденоСуществующееДвижение,
		|	ДЕНЬ(ВложенныйЗапрос.Период) КАК День
		|ИЗ
		|	Документ.ИНАГРО_ИзменениеШтатногоРасписанияОрганизаций.ШтатныеЕдиницы КАК СтрокиДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИНАГРО_ИзменениеШтатногоРасписанияОрганизаций.ШтатныеЕдиницы КАК ПересекающиесяСтроки
		|		ПО СтрокиДокумента.Ссылка = ПересекающиесяСтроки.Ссылка
		|			И СтрокиДокумента.Подразделение = ПересекающиесяСтроки.Подразделение
		|			И СтрокиДокумента.Должность = ПересекающиесяСтроки.Должность
		|			И СтрокиДокумента.НомерСтроки < ПересекающиесяСтроки.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ИНАГРО_ШтатноеРасписаниеОрганизацийСрезПоследних.Период КАК Период,
		|			ИНАГРО_ШтатноеРасписаниеОрганизацийСрезПоследних.Регистратор КАК Регистратор,
		|			ИНАГРО_ШтатноеРасписаниеОрганизацийСрезПоследних.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
		|			ИНАГРО_ШтатноеРасписаниеОрганизацийСрезПоследних.Должность КАК Должность,
		|			ИНАГРО_ШтатноеРасписаниеОрганизацийСрезПоследних.Организация КАК Организация,
		|			ИНАГРО_ШтатноеРасписаниеОрганизацийСрезПоследних.КоличествоСтавок КАК КоличествоСтавок
		|		ИЗ
		|			РегистрСведений.ИНАГРО_ШтатноеРасписаниеОрганизаций.СрезПоследних(
		|					&ДатаДока1,
		|					ПодразделениеОрганизации В
		|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|							ИзменениеШтатногоРасписанияОрганизацииШтатныеЕдиницы.Подразделение
		|						ИЗ
		|							Документ.ИНАГРО_ИзменениеШтатногоРасписанияОрганизаций.ШтатныеЕдиницы КАК ИзменениеШтатногоРасписанияОрганизацииШтатныеЕдиницы
		|						ГДЕ
		|							ИзменениеШтатногоРасписанияОрганизацииШтатныеЕдиницы.Ссылка = &ДокументСсылка)) КАК ИНАГРО_ШтатноеРасписаниеОрганизацийСрезПоследних
		|		ГДЕ
		|			НЕ ИНАГРО_ШтатноеРасписаниеОрганизацийСрезПоследних.Регистратор = &ДокументСсылка) КАК ВложенныйЗапрос
		|		ПО СтрокиДокумента.Подразделение = ВложенныйЗапрос.ПодразделениеОрганизации
		|			И СтрокиДокумента.Должность = ВложенныйЗапрос.Должность
		|ГДЕ
		|	СтрокиДокумента.Ссылка = &ДокументСсылка
		|
		|СГРУППИРОВАТЬ ПО
		|	СтрокиДокумента.НомерСтроки,
		|	СтрокиДокумента.Подразделение,
		|	СтрокиДокумента.Должность,
		|	СтрокиДокумента.КоличествоСтавок,
		|	СтрокиДокумента.СозданоНовыхРабочихМест,
		|	СтрокиДокумента.МинимальнаяТарифнаяСтавка,
		|	СтрокиДокумента.МаксимальнаяТарифнаяСтавка,
		|	СтрокиДокумента.ВидТарифнойСтавки,
		|	СтрокиДокумента.ГрафикРаботы,
		|	СтрокиДокумента.СпособОтраженияВБухучете,
		|	СтрокиДокумента.ОсновноеНачисление,
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.Подразделение.Владелец <> &Организация
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ,
		|	ВложенныйЗапрос.КоличествоСтавок,
		|	ДЕНЬ(ВложенныйЗапрос.Период),
		|	ВЫБОР
		|		КОГДА НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаДока, ДЕНЬ)
		|			ТОГДА ВложенныйЗапрос.Регистратор.Представление
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ";
				   
	Возврат Запрос.Выполнить();

КонецФункции

// Формирует запрос по таблице "Надбавки" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоНадбавки(Режим)
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СтрокиДокумента.НомерСтроки КАК НомерСтроки,
		|	СтрокиДокумента.Подразделение КАК Подразделение,
		|	СтрокиДокумента.Должность КАК Должность,
		|	СтрокиДокумента.ВидРасчета КАК ВидРасчета,
		|	СтрокиДокумента.ВидРасчета.СпособРасчета КАК ВидРасчетаСпособРасчета,
		|	СтрокиДокумента.Показатель1 КАК Показатель1,
		|	СтрокиДокумента.Показатель2 КАК Показатель2,
		|	СтрокиДокумента.Показатель3 КАК Показатель3,
		|	СтрокиДокумента.Показатель4 КАК Показатель4,
		|	СтрокиДокумента.Показатель5 КАК Показатель5,
		|	СтрокиДокумента.Показатель6 КАК Показатель6,
		|	СтрокиДокумента.СпособОтраженияВБухучете КАК СпособОтраженияВБухучете,
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.Подразделение.Владелец <> &Организация
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОшибкаПодразделениеНеПринадлежитОрганизации,
		|	МИНИМУМ(ПересекающиесяСтроки.НомерСтроки) КАК КонфликтнаяСтрока,
		|	Надбавки.Регистратор.Представление КАК КонфликтныйДокумент
		|ИЗ
		|	Документ.ИНАГРО_ИзменениеШтатногоРасписанияОрганизаций.Надбавки КАК СтрокиДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИНАГРО_ИзменениеШтатногоРасписанияОрганизаций.Надбавки КАК ПересекающиесяСтроки
		|		ПО СтрокиДокумента.Ссылка = ПересекающиесяСтроки.Ссылка
		|			И СтрокиДокумента.Подразделение = ПересекающиесяСтроки.Подразделение
		|			И СтрокиДокумента.Должность = ПересекающиесяСтроки.Должность
		|			И СтрокиДокумента.НомерСтроки < ПересекающиесяСтроки.НомерСтроки
		|			И СтрокиДокумента.ВидРасчета = ПересекающиесяСтроки.ВидРасчета
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ИНАГРО_НадбавкиПоШтатномуРасписаниюОрганизаций.Период КАК Период,
		|			ИНАГРО_НадбавкиПоШтатномуРасписаниюОрганизаций.Регистратор КАК Регистратор,
		|			ИНАГРО_НадбавкиПоШтатномуРасписаниюОрганизаций.Организация КАК Организация,
		|			ИНАГРО_НадбавкиПоШтатномуРасписаниюОрганизаций.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
		|			ИНАГРО_НадбавкиПоШтатномуРасписаниюОрганизаций.Должность КАК Должность
		|		ИЗ
		|			РегистрСведений.ИНАГРО_НадбавкиПоШтатномуРасписаниюОрганизаций КАК ИНАГРО_НадбавкиПоШтатномуРасписаниюОрганизаций
		|		ГДЕ
		|			НЕ ИНАГРО_НадбавкиПоШтатномуРасписаниюОрганизаций.Регистратор = &ДокументСсылка) КАК Надбавки
		|		ПО СтрокиДокумента.Подразделение = Надбавки.ПодразделениеОрганизации
		|			И СтрокиДокумента.Должность = Надбавки.Должность
		|			И СтрокиДокумента.Ссылка.Дата = Надбавки.Период
		|ГДЕ
		|	СтрокиДокумента.Ссылка = &ДокументСсылка
		|
		|СГРУППИРОВАТЬ ПО
		|	СтрокиДокумента.НомерСтроки,
		|	СтрокиДокумента.Подразделение,
		|	СтрокиДокумента.Должность,
		|	СтрокиДокумента.ВидРасчета,
		|	СтрокиДокумента.Показатель1,
		|	СтрокиДокумента.Показатель2,
		|	СтрокиДокумента.Показатель3,
		|	СтрокиДокумента.Показатель4,
		|	СтрокиДокумента.Показатель5,
		|	СтрокиДокумента.Показатель6,
		|	СтрокиДокумента.СпособОтраженияВБухучете,
		|	СтрокиДокумента.ВидРасчета.СпособРасчета,
		|	ВЫБОР
		|		КОГДА СтрокиДокумента.Подразделение.Владелец <> &Организация
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ,
		|	Надбавки.Регистратор.Представление";
				   
	Возврат Запрос.Выполнить();

КонецФункции

// Проверяет правильность заполнения реквизитов в строке ТЧ "Штатные единицы" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//  							  из результата запроса
//  Отказ 						- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеСтрокиШтатнойЕдиницы(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ)

	СтрокаНачалаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке номер ""%1"" табл. части ""Штатные единицы"": ';uk='У рядку номер ""%1"" табл. частини ""Штатні одиниці"": '"), СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки));
									
	// Подразделение
	Если Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Подразделение) Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не выбрано подразделение!';uk='не обраний підрозділ!'"), Отказ);
	ИначеЕсли ВыборкаПоСтрокамДокумента.ОшибкаПодразделениеНеПринадлежитОрганизации Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='указано подразделение другой организации!';uk='вказано підрозділ іншої організації!'"), Отказ);      
	КонецЕсли;

	// Должность
	Если Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Должность) Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не указана должность!';uk='не зазначена посада!'"), Отказ);
	КонецЕсли;

	// КоличествоСтавок требуем только для новых строк
	Если Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КоличествоСтавок) И Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.БылоСтавок) И Не ВыборкаПоСтрокамДокумента.БылоСтавок = null Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке +  НСтр("ru='не указано количество ставок по создаваемой штатной единице!';uk='не зазначено кількість ставок по створюваній штатній одиниці!'"), Отказ);
	КонецЕсли;

	// если строка шт.расписания вычеркивается - проверяем не все
	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КоличествоСтавок) Или Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.БылоСтавок) Тогда
		
		// ВидТарифнойСтавки
		Если Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ВидТарифнойСтавки) Тогда
			ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не указан вид тарифной ставки!';uk='не вказано вид тарифної ставки!'"), Отказ);
		КонецЕсли;
		
		// ГрафикРаботы
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ГрафикРаботы) Тогда
			ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не указан график работы!';uk='не вказано графік роботи!'"), Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	// повторяющиеся строки
	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока) Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='в строке № ';uk='в рядку № '") + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока +  НСтр("ru=' повторно описывается та же штатная единица!';uk=' повторно описується та ж штатна одиниця!'"), Отказ);
	КонецЕсли;
	
	// конфликтующий документ
	Если ВыборкаПоСтрокамДокумента.НайденоСуществующееДвижение <> Ложь Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='документом ';uk='документом '") + ВыборкаПоСтрокамДокумента.НайденоСуществующееДвижение + НСтр("ru=' штатная единица уже описана!';uk=' штатна одиниця вже описана'"), Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиШтатнойЕдиницы()

// Проверяет правильность заполнения реквизитов в строке ТЧ "Надбавки" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//  							  из результата запроса
//  Отказ 						- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеСтрокиНадбавок(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ)

	СтрокаНачалаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке номер ""%1"" табл. части ""Надбавки"": ';uk='У рядку номер ""%1"" табл. частини ""Надбавки"": '"), СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки));
	
	// Подразделение
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Подразделение) Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не выбрано подразделение!';uk='не обраний підрозділ!'"), Отказ);
	ИначеЕсли ВыборкаПоСтрокамДокумента.ОшибкаПодразделениеНеПринадлежитОрганизации Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='указано подразделение, принадлежащее другой организации!';uk='вказано підрозділ, що належить іншій організації!'"), Отказ);
	КонецЕсли;

	// Должность
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Должность) Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не указана должность!';uk='не зазначена посада!'"), Отказ);
	КонецЕсли;

	// ВидРасчета
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ВидРасчета) Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не выбрана надбавка!';uk='не зазначена надбавка!'"), Отказ);
	КонецЕсли;

	// повторяющиеся строки
	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока) Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='""%1"" в строке № %2 повторно описывается та же надбавка!';uk='""%1"" в рядку № %2 повторно описується та ж надбавка!'"), СтрокаНачалаСообщенияОбОшибке, ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока), Отказ);
	КонецЕсли;
	
	// конфликтующий документ
	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КонфликтныйДокумент) Тогда
		ОбщегоНазначенияБПКлиентСервер.СообщитьОбОшибке(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='""%1"" документом %2 надбавка по штатной единице уже описана!';uk='""%1"" документом %2 надбавка по штатній одиниці вже описана!'"), СтрокаНачалаСообщенияОбОшибке, ВыборкаПоСтрокамДокумента.КонфликтныйДокумент), Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиНадбавок()

// По строке выборки результата запроса по документу формируем движения по регистрам.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров 
//                                           сведений по которым надо проводить документ,
//  СтруктураПараметров                    - структура параметров проведения.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВШтатноеРасписание(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, 
		  СтруктураПроведенияПоРегистрамСведений, СтруктураПараметров = "")

	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "ИНАГРО_ШтатноеРасписаниеОрганизаций";
	Движения[ИмяРегистра].Записывать = Истина;
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда

		Движение = Движения[ИмяРегистра].Добавить();

		// Свойства
		Движение.Период						= ВыборкаПоШапкеДокумента  .Дата;

		// Измерения
		Движение.ПодразделениеОрганизации	= ВыборкаПоСтрокамДокумента.Подразделение;
		Движение.Должность					= ВыборкаПоСтрокамДокумента.Должность;

		// Ресурсы
		Движение.КоличествоСтавок			= ВыборкаПоСтрокамДокумента.КоличествоСтавок;
		Движение.МинимальнаяТарифнаяСтавка	= ВыборкаПоСтрокамДокумента.МинимальнаяТарифнаяСтавка;
		Движение.МаксимальнаяТарифнаяСтавка = ВыборкаПоСтрокамДокумента.МаксимальнаяТарифнаяСтавка;
		Движение.ВидТарифнойСтавки			= ВыборкаПоСтрокамДокумента.ВидТарифнойСтавки;
		Движение.ГрафикРаботы				= ВыборкаПоСтрокамДокумента.ГрафикРаботы;
		Движение.СпособОтраженияВБухучете	= ВыборкаПоСтрокамДокумента.СпособОтраженияВБухучете;
		Движение.ОсновноеНачисление			= ВыборкаПоСтрокамДокумента.ОсновноеНачисление;
		// Реквизиты
		Движение.СозданоНовыхРабочихМест	= ВыборкаПоСтрокамДокумента.СозданоНовыхРабочихМест;
		
	КонецЕсли; 
					
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

// По строке выборки результата запроса по документу формируем движения по регистрам.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров 
//                                           сведений по которым надо проводить документ,
//  СтруктураПараметров                    - структура параметров проведения.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуНадбавок(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, 
	СтруктураПроведенияПоРегистрамСведений, СтруктураПараметров = "")
	  
	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "ИНАГРО_НадбавкиПоШтатномуРасписаниюОрганизаций";
	Движения[ИмяРегистра].Записывать = Истина;
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда
		  
		Движение = Движения[ИмяРегистра].Добавить();
		  
		// Свойства
		Движение.Период						= ВыборкаПоШапкеДокумента  .Дата;
		  
		// Измерения
		Движение.ПодразделениеОрганизации		= ВыборкаПоСтрокамДокумента.Подразделение;
		Движение.Должность					= ВыборкаПоСтрокамДокумента.Должность;
		Движение.ВидНадбавки					= ВыборкаПоСтрокамДокумента.ВидРасчета;
		  
		// Ресурсы
		Движение.Показатель1					= ВыборкаПоСтрокамДокумента.Показатель1;
		Движение.Показатель2					= ВыборкаПоСтрокамДокумента.Показатель2;
		Движение.Показатель3					= ВыборкаПоСтрокамДокумента.Показатель3;
		Движение.Показатель4					= ВыборкаПоСтрокамДокумента.Показатель4;
		Движение.Показатель5					= ВыборкаПоСтрокамДокумента.Показатель5;
		Движение.Показатель6					= ВыборкаПоСтрокамДокумента.Показатель6;
		Движение.СпособОтраженияВБухучете		= ВыборкаПоСтрокамДокумента.СпособОтраженияВБухучете;
		  
	КонецЕсли;
				
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

// Создает и заполняет структуру, содержащую имена регистров сведений 
//  по которым надо проводить документ.
//
// Параметры: 
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров сведений 
//                                           по которым надо проводить документ.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений)

	СтруктураПроведенияПоРегистрамСведений = Новый Структура();
	
	СтруктураПроведенияПоРегистрамСведений.Вставить("ИНАГРО_ШтатноеРасписаниеОрганизаций");
	СтруктураПроведенияПоРегистрамСведений.Вставить("ИНАГРО_НадбавкиПоШтатномуРасписаниюОрганизаций");

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамСведений

#КонецОбласти

#КонецЕсли