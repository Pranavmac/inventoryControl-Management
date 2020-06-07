ActiveRecord::Schema.define(version: 20170423144447) do
 create_table "items", force: :cascade do |t|
   t.string   "name"
   t.string   "category"
   t.integer  "quantity"
   t.text     "description"
   t.datetime "created_at",         null: false
   t.datetime "updated_at",         null: false
   t.integer  "remaining_quantity"
 end

 create_table "members", force: :cascade do |t|
   t.string   "name"
   t.string   "email"
   t.string   "phone"
   t.datetime "created_at", null: false
   t.datetime "updated_at", null: false
 end

 create_table "orders", force: :cascade do |t|
   t.string   "quantity"
   t.boolean  "status"
   t.date     "expire_at"
   t.integer  "item_id"
   t.integer  "member_id"
   t.datetime "created_at", null: false
   t.datetime "updated_at", null: false
   t.index ["item_id"], name: "index_orders_on_item_id"
   t.index ["member_id"], name: "index_orders_on_member_id"
 end

 create_table "users", force: :cascade do |t|
   t.string   "name"
   t.datetime "created_at",                          null: false
   t.datetime "updated_at",                          null: false
   t.string   "email",                  default: "", null: false
   t.string   "encrypted_password",     default: "", null: false
   t.string   "reset_password_token"
   t.datetime "reset_password_sent_at"
   t.datetime "remember_created_at"
   t.integer  "sign_in_count",          default: 0,  null: false
   t.datetime "current_sign_in_at"
   t.datetime "last_sign_in_at"
   t.string   "current_sign_in_ip"
   t.string   "last_sign_in_ip"
   t.index ["email"], name: "index_users_on_email", unique: true
   t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
 end
End

Home Page: (The code for other pages is similar and hence omitted)
<body class="hold-transition skin-blue sidebar-mini">
  <div class="wrapper">
    <%= render 'layouts/header' %>
    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
      <!-- Content Header (Page header) -->
      <section class="content-header">
        <h1>
          Dashboard
          <small>Control panel</small>
        </h1>
        <ol class="breadcrumb">
          <li class="active">
            <a href="#">
              <i class="fa fa-home"></i>
              Home Page</a>
          </li>
        </ol>
      </section>
      <!-- Main content -->
      <section class="content">
        <!-- Small boxes (Stat box) -->
        <div class="row">
          <div class="col-lg-3 col-xs-6">
            <!-- small box -->
            <div class="small-box bg-aqua">
              <div class="inner">
                <h3><%=@items.sum(:quantity)%></h3>
                <p>Items Tracked</p>
              </div>
              <div class="icon">
                <i class="ion ion-search"></i>
              </div>
            </div>
          </div>
          <!-- ./col -->
          <div class="col-lg-3 col-xs-6">
            <!-- small box -->
            <div class="small-box bg-green">
              <div class="inner">
                <h3><%=@items.sum(:remaining_quantity)%></h3>
                <p>Items Available</p>
              </div>
              <div class="icon">
                <i class="ion ion-checkmark"></i>
              </div>
            </div>
          </div>
          <!-- ./col -->
          <div class="col-lg-3 col-xs-6">
            <!-- small box -->
            <div class="small-box bg-red">
              <div class="inner">
                <h3><%= (@items.sum(:quantity) - @items.sum(:remaining_quantity)) %></h3>
                <p>Items Unavailable</p>
              </div>
              <div class="icon">
                <i class="ion ion-alert"></i>
              </div>
            </div>
          </div>
          <!-- ./col -->
          <div class="col-lg-3 col-xs-6">
            <!-- small box -->
            <div class="small-box bg-yellow">
              <div class="inner">
                <h3><%= @expired.count %></h3>
                <p>Expired Orders</p>
              </div>
              <div class="icon">
                <i class="ion ion-android-time"></i>
              </div>
            </div>
          </div>
          <!-- ./col -->
        </div>
        <!-- /.row -->

        <div class="row">
          <div class="col-md-6">
            <div class="box">
              <div class="box-header with-border">
                <h3 class="box-title">Orders (<%= @active.count %>)</h3>
              </div>
              <!-- /.box-header -->
              <div class="box-body">
                <table class="table table-bordered table-hover">
                  <thead>
                    <tr>
                      <th>Description</th>
                      <th>Qty</th>
                      <th>Return By</th>
                      <th>Borrowed By</th>
                      <th>
                        <i class="ion ion-log-in"></i>
                      </th>
                      <th>
                        <i class="ion ion-loop"></i>
                      </th>
                      <th>
                        <i class="ion ion-trash-b"></i>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <% @active.each do |order| %>
                    <tr>
                      <td>
                        <%= order.item.name %>
                      </td>
                      <td><%= order.quantity %></td>
                      <% if order.expire_at.strftime("%y:%m:%d") >= Date.today.strftime("%y:%m:%d") %>
                      <td>
                        <%= order.expire_at %>
                      </td>
                    <% else %>
                      <td style="color:red;">
                        <%= order.expire_at %>
                      </td>
                      <% end %>
                      <td>
                        <%= order.member.name %>
                      </td>
                      <td>
                        <%= link_to "", { :controller => :orders, :action => :disable, :id => order.id }, { class: "ion ion-log-in"} %>
                      </td>
                      <td>
                        <%= link_to "", { :controller => :orders, :action => :renew, :id => order.id }, { class: "ion ion-loop"} %>
                      </td>
                      <td >
                        <%= link_to order, method: :delete, data: { confirm: 'Are you sure? If you are trying to return an item it is recommended to use the "return" button.' } do %>
                        <i class="ion ion-trash-b"></i>
                        <% end %>
                      </td>
                    </tr>
                    <% end %>
                  </tbody>
                </table>
              </div>
            </div>
            <!-- /.box -->
          </div>
          <!-- ./col -->

          <div class="col-md-6">
            <div class="box">
              <div class="box-header with-border">
                <h3 class="box-title">Members (<%= @members.count %>)</h3>
              </div>
              <!-- /.box-header -->
              <div class="box-body">
                <table class="table table-bordered table-hover">
                  <tr>
                    <th>Name</th>
                    <th>E-mail</th>
                    <th>Phone</th>
                    <th>
                      <i class="ion ion-edit"></i>
                    </tr><th>
                      <i class="ion ion-trash-b"></i>
                    </th> </tr>
                  <% @members.each do |member| %>
                  <tr>
                    <td><%= member.name %></td>
                    <td><%= member.email %></td>
                    <td><%= member.phone %></td>
                    <td><%= link_to "", edit_member_path(member), { class: "ion ion-edit"} %></td>
                    <td>
                      <%= link_to member, method: :delete, data: { confirm: 'Are you sure?' } do %>
                      <i class="ion ion-trash-b"></i>
                      <% end %>
                    </td></tr>
                  <% end %>
                </table>  </div>
            </div>
            <!-- /.box -->
          </div>
          <!-- ./col -->
        </div>
        <!-- /.row -->
      </section>
      <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->
    <%= render 'layouts/footer' %>
    <script>
      $.widget.bridge('uibutton', $.ui.button);
    </script>
    <script>
      $(function () {
        $("#example1").DataTable();
        $('#example2').DataTable({
          "paging": true,
          "lengthChange": false,
          "searching": false,
          "ordering": true,
          "info": true,
          "autoWidth": false
        });      });
    </script>
  </body>

