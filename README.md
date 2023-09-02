## YApi-自由 Mock

#### 为了方便使用，同时也是我们的需求：定义多个入参相同出参不同的 Mock，通过开启和关闭 Mock 来控制

修改 yapi/vendors/exts/yapi-plugin-advanced-mock/controller.js

```javascript
findRepeatParams = {
  project_id: data.project_id,
  interface_id: data.interface_id,
  ip_enable: data.ip_enable,
  // 添加一个name的检查条件，允许添加相同入参期望名称不同的Mock
  name: data.name
};
```

#### 为了方便部署，添加 Docker 支持

修改 config-yapi.json

```
{
  "port": "3000",
  "adminAccount": "admin@admin.com",
  "timeout": 120000,
  "db": {
    "servername": "mongo",
    "DATABASE": "yapi",
    "port": 27017,
    "user": "root",
    "pass": "chenhui",
    "authSource": "admin"
  },
  "mail": {
    "enable": false
  },
  "closeRegister": false
}

```

docker-compose.yml

```yaml
version: '3.9'
services:
  mongo:
    image: mongo
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: root

  yapi:
    # image: ahuinee/yapi-free-mock:latest
    build: .
    restart: always
    volumes:
      - ./config-yapi.json:/yapi/config.json
    depends_on:
      - mongo
    ports:
      - 3000:3000
```

初始化管理员（如果已经初始化就不需要这一步）
进入 Dokcer 容器然后执行

```
/yapi/vendors # npm run install-server
```

重启容器即可
