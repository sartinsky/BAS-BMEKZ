#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
	
//////////////////////////////////////////////////////////////////
/// Первоначальное заполнение и обновление информационной базы

Процедура ЗаполнитьОрганизацию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НачисленияУдержанияПоСотрудникам.Регистратор КАК Ссылка,
	|	НачисленияУдержанияПоСотрудникам.Регистратор.Организация КАК Организация
	|ИЗ
	|	РегистрНакопления.НачисленияУдержанияПоСотрудникам КАК НачисленияУдержанияПоСотрудникам
	|ГДЕ
	|	НачисленияУдержанияПоСотрудникам.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НАЧАЛОПЕРИОДА(НачисленияУдержанияПоСотрудникам.Регистратор.Дата, ГОД),
	|	НачисленияУдержанияПоСотрудникам.Регистратор.Организация,
	|	НачисленияУдержанияПоСотрудникам.Регистратор.Номер";
	
	ВыборкаРегистраторов = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаРегистраторов.Следующий() Цикл
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Значение = ВыборкаРегистраторов.Ссылка;
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		
		НаборЗаписей.Прочитать();
		
		Для Каждого Запись Из НаборЗаписей Цикл
			Запись.Организация = ВыборкаРегистраторов.Организация;
		КонецЦикла;	
		
		НаборЗаписей.Записать();
		
	КонецЦикла
	
КонецПроцедуры	
#КонецЕсли