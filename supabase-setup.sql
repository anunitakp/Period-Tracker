-- Run this once in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run

create table if not exists period_days (
  day date primary key,
  created_at timestamptz not null default now()
);

create table if not exists app_settings (
  id int primary key default 1,
  cycle_len int not null default 28,
  period_len int not null default 5,
  constraint single_row check (id = 1)
);

insert into app_settings (id, cycle_len, period_len)
values (1, 28, 5)
on conflict (id) do nothing;

-- Open access (no login), matching the "keep it open" choice.
-- Anyone with your anon key + project URL could read/write this data.
alter table period_days enable row level security;
alter table app_settings enable row level security;

create policy "public read period_days" on period_days for select using (true);
create policy "public write period_days" on period_days for insert with check (true);
create policy "public delete period_days" on period_days for delete using (true);

create policy "public read app_settings" on app_settings for select using (true);
create policy "public update app_settings" on app_settings for update using (true);
