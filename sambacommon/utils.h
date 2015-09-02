#ifndef UTILS_H
#define UTILS_H

#include <QQmlListProperty>

/**
 * @ingroup Engine
 * @brief Helper class which creates QQmlListProperty objects directly on QList members fields.
 *
 * The location of the member field is declared as a template parameter.
 * The location of the change signal is passed as the QQmlListProperty's user data. It may be null.
 *
 * @note QQmlListProperty has a constructor which takes a reference to a QList, but we cannot
 * use it. According to the Qt documentation:
 * "Convenience constructor for making a QQmlListProperty value from an existing QList list. The
 * list reference must remain valid for as long as object exists. object must be provided.
 * Generally this constructor should not be used in production code, as a writable QList
 * violates QML's memory management rules. However, this constructor can very useful while
 * prototyping."
 *
 * Code initially from VoltAir project: http://google.github.io/VoltAir
 */
template <typename TObject, typename TData, typename TListType, TListType TObject::* TObjectField,
		void (TObject::* TChangeFunc)() = NULL>
class QQmlListPropertyOnQList {
public:

	/**
	 * @brief Create and return a QQmlListProperty<TData>.
	 */
	static QQmlListProperty<TData> createList(TObject* owner) {
		return QQmlListProperty<TData>(
				owner,
				NULL,
				&QQmlListPropertyOnQList::appendFunc,
				&QQmlListPropertyOnQList::countFunc,
				&QQmlListPropertyOnQList::atFunc,
				&QQmlListPropertyOnQList::clearFunc);
	}

private:
	static void appendFunc(QQmlListProperty<TData>* property, TData* value) {
		TObject* owner = static_cast<TObject*>(property->object);
		TListType& list = (owner->*TObjectField);
		list.append(value);
		callChangeFunc(property);
	}

	static int countFunc(QQmlListProperty<TData>* property) {
		TObject* owner = static_cast<TObject*>(property->object);
		TListType& list = (owner->*TObjectField);
		return list.size();
	}

	static TData* atFunc(QQmlListProperty<TData>* property, int index) {
		TObject* owner = static_cast<TObject*>(property->object);
		TListType& list = (owner->*TObjectField);
		return list.at(index);
	}

	static void clearFunc(QQmlListProperty<TData>* property) {
		TObject* owner = static_cast<TObject*>(property->object);
		TListType& list = (owner->*TObjectField);
		list.clear();
		callChangeFunc(property);
	}

	static void callChangeFunc(QQmlListProperty<TData>* property) {
		TObject* owner = static_cast<TObject*>(property->object);
		if (TChangeFunc) {
			(owner->*TChangeFunc)();
		}
	}
};

#endif // UTILS_H
