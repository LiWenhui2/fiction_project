/*
 * 封装网络请求
 *  - 封装总体请求
 *  - 封装相应方法 get post put delete
 *  - 请求和响应拦截器
 *      + 请求拦截器是在请求之前对象每次请求进行处理  cookie  token
 *      + 响应拦截器是对响应回来的结果（数据）进行处理
 * */
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';


interface configType<T> {
  method?: 'GET' | 'POST' | 'PUT' | 'DELETE',
  header?: Record<string, string>
  param?: Record<string, string>,
  data?: T
}

interface interceptorType {
  request?: <T>(config: configType<T>) => configType<T>
  response?: <T, S>(config: configType<T>) => S
}

function assign(t: Record<string, string>, ...obj: Record<string, string>[]): Record<string, string> {
  for (const item of obj) {
    for (const k of Object.keys(item)) {
      t[k] = Reflect.get(item, k)
    }
  }
  return t
}

class HttpRequest {
  // 封装的请求都是基于原生的 http 进行封装，需要有一个原生的 http 对象
  private httpRequest: http.HttpRequest
  // 设计请求和响应拦截器
  private interceptor: interceptorType = {}
  // 设计配置请求根路径
  public baseUrl: string = ''

  constructor() {
    this.httpRequest = http.createHttp()
  }

  // 封装设置请求拦截器的方法
  setRequestInterceptor(interceptor: <T>(config: configType<T>) => configType<T>) {
    this.interceptor.request = interceptor
  }

  // 封装设置响应拦截器的方法
  setResponseInterceptor(interceptor: <T, S>(config: configType<T>) => S) {
    this.interceptor.response = interceptor
  }

  // 封装请求的总体方法
  request<T = string>(url: string, config: configType<T>): Promise<object> {
    return new Promise((success, fail) => {
      let urlStr = this.baseUrl + url
      if (config?.param) {
        let str = Object.keys(config.param).map(k => `${k}=${config.param![k]}`).join('&')
        urlStr += `?${str}`
      }
      if (this.interceptor.request) {
        let obj = this.interceptor.request(config)
        config.header = assign(config?.header || {}, obj.header || {})
      }

      // 对 POST PUT 发送的数据进行处理
      let dataStr = ''
      if (config.data) {
        dataStr =
          Object.keys(config.data).map(k => `${encodeURI(k)}=${encodeURI(((config.data!) as object)[k])}`).join('&')
      }

      this.httpRequest.request(urlStr, {
        method: config?.method as http.RequestMethod || http.RequestMethod.GET,
        header: assign({ 'content-type': 'application/x-www-form-urlencoded' }, config?.header || {}),
        extraData: config?.data ? dataStr : undefined
      }).then(res => {
        if (typeof res.result == 'string') {
          res.result = JSON.parse(res.result)
        }
        success(res.result as object)
      }).catch((err: BusinessError) => {
        fail(err)
      })
    })
  }

  // 封装 GET 请求
  async get(url: string, header?: Record<string, string>, param?: Record<string, string>): Promise<object> {
    return this.request(url, { param, header })
  }

  // 封装 POST 请求
  async post<T>(url: string, data: T, header?: Record<string, string>,): Promise<object> {
    return this.request(url, { method: 'POST', data, header })
  }

  // 封装 PUT 请求
  async put<T>(url: string, data: T, header?: Record<string, string>,): Promise<object> {
    return this.request(url, { method: 'PUT', data, header })
  }

  // 封装 DELETE 请求
  async delete(url: string, header?: Record<string, string>, param?: Record<string, string>): Promise<object> {
    return this.request(url, { method: 'DELETE', param, header })
  }
}

enum baseurl {
  // 开发阶段的测试地址
  DEVELOP = 'http://192.168.1.45:3333/api',
  // 上线阶段的实际地址
  PRODUCT = 'http://43.159.41.42:3333/api'
}

let axios = new HttpRequest()

axios.baseUrl = baseurl.DEVELOP
axios.baseUrl = baseurl.PRODUCT

export default axios

