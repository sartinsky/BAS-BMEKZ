Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

Процедура ДобавитьДвижение() Экспорт
	
	мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "Период");
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");

	ОбщегоНазначенияРед12.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);
	
КонецПроцедуры // ДобавитьДвижение()
