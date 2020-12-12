import axios, { AxiosError } from 'axios'

export interface CheckRequest {
  doc: string
}

export interface CheckResponce {
  point: number
}

const URL = '/patio/check'

export const post = (requestData: CheckRequest, callback:(data: CheckResponce) => void): void => {
  const request = axios.create({
    headers: { 'Content-Type': 'application/json' },
  })
  request.post<CheckResponce>(
    URL,
    requestData
  ).then(
    res => callback(res.data)
  ).catch(
    (e: AxiosError) => console.error(e)
  )
}
