import * as React from 'react'
import * as CheckApi from 'api/check'
import { useForm } from 'react-hook-form'
import styled from 'styled-components'
import { Header } from 'components/Header'
import { ResultText } from 'components/ResultText'
import { TweetButton } from 'components/TweetButton'

const SubmitButton = styled.input`
height: 3rem;
font-size: 2rem;
width: 100%;

display: block;
background-color:rgba(16,255,0,0.8);
color:rgb(255,255,255);
flex: 0 0 35rem;
`
const TextInput = styled.textarea`
width: 100%;
font-family: 'Kosugi Maru', sans-serif;
background-color: transparent;
text-shadow: #4aff53 1px 0 0.2rem;
font-size: 2rem;
text-align: center;
padding: 10px;
resize: none;
color: #fd6500;
display: block;
border-top-color: rgba(0, 0, 0, 0.4);
border-left-color: rgba(0, 0, 0, 0.2);
border-right-color: rgba(255, 255, 255, 0.2);
border-bottom-color: rgba(255, 255, 255, 0.4);
margin-bottom: 1rem;
`

const Sheet=styled.div`
background-color: rgba(255, 255, 255, 0.5);
`

const DocumentForm = styled.form`
width: 100%;
border-style: solid;
border-width: 1px 0px 0px 0px;
border-color: rgba(255,255,255, 0.3);
padding-top: 2rem;
padding-bottom: 2rem;
max-width: 900px;
margin: auto;
`

const BarWrapper = styled.div`
width: 95%;
margin: 0 auto;
`

const Bar = styled.div`
transition: width 2s ease-in;
width: ${props => props.theme.barWidth};
background-color: #4aff53;
height: 2em;
`

Bar.defaultProps = {
  theme:{
    barWidth: '0px'
  }
}

const Container = styled.div`
width: 75%;
margin: 5rem auto;
min-width: 40rem;
max-width: 1200px;
`

export const App: React.FC = () => {
  const { register, handleSubmit } = useForm();
  const [ point, setPoint ] = React.useState(0);
  const [ document, setDocument ] = React.useState("");
  const [ visibleResult, setVisibleResult ] = React.useState(false)

  const submit = (data: CheckApi.CheckRequest) => {
    CheckApi.post(data, (response) => { 
      if(data.doc !== ''){
        setVisibleResult(true)
        setDocument(data.doc)
        setPoint(response.point)
      }
    })
  }
  const convertPointToBarWidth = (point: number) => ({ barWidth: (point === 0 ? `${point}px` : `${point}%`)});
  
  return(
    <div>
      <Header />
      <Container>
        <Sheet>
          <BarWrapper>
            <ResultText visible={visibleResult} document={document} point={point} />
            <Bar theme={convertPointToBarWidth(point)} />
          </BarWrapper>
          <DocumentForm onSubmit={handleSubmit(submit)}>
            <TextInput name='doc' rows={3} cols={32} ref={register} onChange={() => { setPoint(0); setVisibleResult(false) }} />
            <SubmitButton type='submit' value='Submit' />
          </DocumentForm>
          <TweetButton doc={document} point={point} />
        </Sheet>
      </Container>
    </div>
  )
};
