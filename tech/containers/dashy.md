webapp dashboard

`docker run -dp 8080:80 -v ~/my-conf.yml:/app/public/conf.yml --name my-dashboard --restart=always lissy93/dashy:latest`
`http://localhost:8080`

```
pageInfo:
  title: Home Lab
sections: # An array of sections
- name: Example Section
  icon: far fa-rocket
  items:
  - title: GitHub
    description: Dashy source code and docs
    icon: fab fa-github
    url: https://github.com/Lissy93/dashy
  - title: Issues
    description: View open issues, or raise a new one
    icon: fas fa-bug
    url: https://github.com/Lissy93/dashy/issues
- name: Local Services
  items:
  - title: Firewall
    icon: favicon
    url: http://192.168.1.1/
  - title: Game Server
    icon: https://i.ibb.co/710B3Yc/space-invader-x256.png
    url: http://192.168.130.1/
```
- [`pageInfo`](https://github.com/Lissy93/dashy/blob/master/docs/configuring.md#pageinfo) - Dashboard meta data, like title, description, nav bar links and footer text
- [`appConfig`](https://github.com/Lissy93/dashy/blob/master/docs/configuring.md#appconfig-optional) - Dashboard settings, like themes, authentication, language and customization
- [`sections`](https://github.com/Lissy93/dashy/blob/master/docs/configuring.md#section) - An array of sections, each including an array of items