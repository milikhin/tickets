#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QStandardPaths>
#include <QDir>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    // set app name to match UBports notation
    app.setApplicationName("tickets.mikhael");

    // create config path to save search preferences if not exists
    QString configPath = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    QDir dir(configPath);
    if (!dir.exists())
        dir.mkpath(".");

    QQuickStyle::setStyle("Suru");
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
