
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Перем мВерсияОтчета Экспорт;
Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
		
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);
	

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013УФ";
	НоваяФорма.ОписаниеОтчета     =  НСтр("ru='Приложение к НП(С)БУ №1 ""Общие требования к финансовой отчетности"" с изменениями внесенными Приказом Минфина Украины от 07.02.2013 №73';uk='Додаток до НП(С)БО №1 ""Загальні вимоги до фінансової звітності"" зі змінами внесеними Наказом Мінфіну України від 07.02.2013 №73'");
	НоваяФорма.ДатаНачалоДействия = '2013-01-01';
	НоваяФорма.ДатаКонецДействия  = Неопределено;
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

мВерсияОтчета = "БУ 2.0.1.1.1";

#КонецЕсли

