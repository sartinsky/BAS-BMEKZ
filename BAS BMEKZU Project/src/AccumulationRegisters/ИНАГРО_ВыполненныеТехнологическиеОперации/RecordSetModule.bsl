#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Перем мПериод Экспорт;  //Хранит период
Перем мТаблицаДвижений Экспорт; //Хранит таблицу движений

#Область Проведение

// Выполняет движение по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижение() Экспорт
	
	ОбщегоНазначенияРед12.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли