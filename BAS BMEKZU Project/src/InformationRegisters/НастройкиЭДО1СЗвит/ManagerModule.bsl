
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

Функция СписокВыгружаемыхДокументов() Экспорт

	Список = Новый СписокЗначений;
	
	
	Список.Добавить("АктОбОказанииПроизводственныхУслуг");
	Список.Добавить("ВозвратТоваровПоставщику");
	Список.Добавить("ОтчетКомитентуОПродажах");
	Список.Добавить("ПередачаНМА");
	Список.Добавить("ПередачаОС");
	Список.Добавить("ПередачаТоваров");
	Список.Добавить("РеализацияТоваровУслуг");
	Список.Добавить("РеализацияУслугПоПереработке");
	Список.Добавить("СчетНаОплатуПокупателю");
	Список.Добавить("РеализацияУслугПоПереработке");

	Для каждого Элемент Из Список Цикл
		Элемент.Представление = Метаданные.Документы[Элемент.Значение].Представление();	
	КонецЦикла;
	
	Возврат Список;
	
КонецФункции 

Функция СписокЗагружаемыхДокументов() Экспорт

	Список = Новый СписокЗначений;
	Список.Добавить("ВозвратТоваровОтПокупателя");
	Список.Добавить("ОтчетКомиссионераОПродажах");
	Список.Добавить("ПоступлениеНМА");
	Список.Добавить("ПоступлениеТоваровУслуг");
	Список.Добавить("ПоступлениеДопРасходов");
	Список.Добавить("ПоступлениеИзПереработки");
	Список.Добавить("СчетНаОплатуПоставщика");
	Список.Добавить("ОтчетКомиссионераОПродажах");
	Список.Добавить("ОтчетКомиссионераОПродажах");
	
	Для каждого Элемент Из Список Цикл
		Элемент.Представление = Метаданные.Документы[Элемент.Значение].Представление();	
	КонецЦикла;
	
	Возврат Список;

КонецФункции 
