#include <gtk/gtk.h>
#include <gio/gio.h>
#include <webkit/webkit.h>

static void on_back_clicked(GtkButton *button, gpointer user_data) {
    g_print("Back button pressed\n");
}

static void on_forward_clicked(GtkButton *button, gpointer user_data) {
    g_print("Forward button pressed\n");
}

static void on_reload_clicked(GtkButton *button, gpointer user_data) {
    g_print("Reload button pressed\n");
}

static void on_url_activate(GtkEntry *entry, gpointer user_data) {
    WebKitWebView *web_view = WEBKIT_WEB_VIEW(user_data);
    const char *url = gtk_editable_get_text(GTK_EDITABLE(entry));
    g_print("URL entered: %s\n", url);
    webkit_web_view_load_uri(web_view, url);
}

static void on_bookmarks_activate(GSimpleAction *action, GVariant *parameter, gpointer user_data) {
    g_print("Bookmarks selected\n");
}

static void on_history_activate(GSimpleAction *action, GVariant *parameter, gpointer user_data) {
    g_print("History selected\n");
}

static void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "Simple Browser Prototype");
    gtk_window_set_default_size(GTK_WINDOW(window), 800, 600);

    // Header bar
    GtkWidget *header = gtk_header_bar_new();
    gtk_header_bar_set_show_title_buttons(GTK_HEADER_BAR(header), TRUE);
    gtk_window_set_titlebar(GTK_WINDOW(window), header);

    // Back button
    GtkWidget *back = gtk_button_new_from_icon_name("go-previous-symbolic");
    g_signal_connect(back, "clicked", G_CALLBACK(on_back_clicked), NULL);
    gtk_header_bar_pack_start(GTK_HEADER_BAR(header), back);

    // Forward button
    GtkWidget *forward = gtk_button_new_from_icon_name("go-next-symbolic");
    g_signal_connect(forward, "clicked", G_CALLBACK(on_forward_clicked), NULL);
    gtk_header_bar_pack_start(GTK_HEADER_BAR(header), forward);

    // Reload button
    GtkWidget *reload = gtk_button_new_from_icon_name("view-refresh-symbolic");
    g_signal_connect(reload, "clicked", G_CALLBACK(on_reload_clicked), NULL);
    gtk_header_bar_pack_start(GTK_HEADER_BAR(header), reload);

    // URL entry
    GtkWidget *entry = gtk_entry_new();
    gtk_widget_set_hexpand(entry, TRUE);
    gtk_header_bar_set_title_widget(GTK_HEADER_BAR(header), entry);

    // Menu button for more options
    GtkWidget *menu_button = gtk_menu_button_new();
    gtk_menu_button_set_icon_name(GTK_MENU_BUTTON(menu_button), "open-menu-symbolic");
    gtk_header_bar_pack_end(GTK_HEADER_BAR(header), menu_button);

    // Create menu model
    GMenu *menu = g_menu_new();
    g_menu_append(menu, "Bookmarks", "win.bookmarks");
    g_menu_append(menu, "History", "win.history");

    // Popover for menu
    GtkWidget *popover = gtk_popover_menu_new_from_model(G_MENU_MODEL(menu));
    gtk_menu_button_set_popover(GTK_MENU_BUTTON(menu_button), popover);

    // WebView
    WebKitWebView *web_view = WEBKIT_WEB_VIEW(webkit_web_view_new());
    gtk_window_set_child(GTK_WINDOW(window), GTK_WIDGET(web_view));

    // Load default page and set entry text
    webkit_web_view_load_uri(web_view, "https://www.example.com");
    gtk_editable_set_text(GTK_EDITABLE(entry), "https://www.example.com");

    // Connect URL entry signal (pass web_view as data)
    g_signal_connect(entry, "activate", G_CALLBACK(on_url_activate), web_view);

    // Add actions for menu items
    GSimpleAction *bookmarks_action = g_simple_action_new("bookmarks", NULL);
    g_signal_connect(bookmarks_action, "activate", G_CALLBACK(on_bookmarks_activate), NULL);
    g_action_map_add_action(G_ACTION_MAP(window), G_ACTION(bookmarks_action));

    GSimpleAction *history_action = g_simple_action_new("history", NULL);
    g_signal_connect(history_action, "activate", G_CALLBACK(on_history_activate), NULL);
    g_action_map_add_action(G_ACTION_MAP(window), G_ACTION(history_action));

    // Show the window
    gtk_widget_set_visible(window, TRUE);
}

int main(int argc, char *argv[]) {
    GtkApplication *app = gtk_application_new("org.example.browser", G_APPLICATION_FLAGS_NONE);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    return status;
}
